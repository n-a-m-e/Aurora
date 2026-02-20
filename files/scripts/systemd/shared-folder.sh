#!/bin/bash
set -euo pipefail

# Prevent overlapping runs
exec 9>/run/shared-folder.lock
flock -n 9 || exit 0

umask 002

DIRS=(/home/Shared /home/Node /home/Git /home/Trash /home/Storage /home/Secrets)
USER_FOLDERS=(Desktop Documents Downloads Music Pictures Videos)

# FTP dropbox (printer scans land here)
FTP_USER="ftpsecure"
FTP_BASE="/home/Public"
FTP_UPLOADS="$FTP_BASE/Uploads"

# Ensure group "users" exists
getent group users >/dev/null || groupadd users

FULL=0
FIND_MMIN=(-mmin -70)

# Boot-only logic (first run after boot)
if ( set -o noclobber; : >"/run/shared-folder.boot-done" ) 2>/dev/null; then
  FIND_MMIN=(-mmin -1440)
  if [[ "$(date +%u)" == "1" ]]; then
    FULL=1
  fi
fi

ensure_ftp_user() {
  if ! id -u "$FTP_USER" >/dev/null 2>&1; then
    useradd \
      --system \
      --gid users \
      --shell /usr/sbin/nologin \
      --home-dir /nonexistent \
      --no-create-home \
      "$FTP_USER"
  else
    # Ensure primary group is users
    local cur_gid users_gid
    cur_gid="$(id -g "$FTP_USER")"
    users_gid="$(getent group users | awk -F: '{print $3}')"
    if [[ -n "${users_gid:-}" && "$cur_gid" != "$users_gid" ]]; then
      usermod -g users "$FTP_USER" || true
    fi
  fi
}

ensure_dir_root_users_2770() {
  local d="$1"
  mkdir -p "$d"
  chown root:users "$d"
  chmod 2770 "$d"
}

set_acl_tree_users_rwx() {
  local d="$1"

  if (( FULL )); then
    setfacl -Rb "$d"
    chgrp -R users "$d"
    chmod -R g+rwX,o-rwx "$d"
    find "$d" -type d \
      -exec chmod g+s,o-rwx {} + \
      -exec setfacl -m u::rwx,g::rwx,o::--- {} + \
      -exec setfacl -d -m u::rwx,g::rwx,o::--- {} +
  else
    find "$d" "${FIND_MMIN[@]}" -exec chgrp users {} + -exec chmod g+rwX,o-rwx {} +
    find "$d" -type d "${FIND_MMIN[@]}" \
      -exec chmod g+s,o-rwx {} + \
      -exec setfacl -m u::rwx,g::rwx,o::--- {} + \
      -exec setfacl -d -m u::rwx,g::rwx,o::--- {} +
  fi

  # Ensure top-level ACLs always correct
  setfacl -m  u::rwx,g::rwx,o::--- "$d"
  setfacl -d -m u::rwx,g::rwx,o::--- "$d"
}

ensure_ftp_dropbox() {
  mkdir -p "$FTP_UPLOADS"

  # Container: readable/traversable by group users, not writable
  chown root:users "$FTP_BASE"
  chmod 2755 "$FTP_BASE"

  # Uploads: writable; setgid ensures group 'users' on new files/dirs
  chown "$FTP_USER":users "$FTP_UPLOADS"
  chmod 2775 "$FTP_UPLOADS"

  if (( FULL )); then
    setfacl -b "$FTP_BASE" 2>/dev/null || true
    setfacl -b "$FTP_UPLOADS" 2>/dev/null || true
  fi

  setfacl -m  u::rwx,g::r-x,o::--- "$FTP_BASE"
  setfacl -d -m u::rwx,g::r-x,o::--- "$FTP_BASE"

  setfacl -m  u::rwx,g::rwx,o::--- "$FTP_UPLOADS"
  setfacl -d -m u::rwx,g::rwx,o::--- "$FTP_UPLOADS"
}

ensure_ftp_user
ensure_ftp_dropbox

# Ensure shared top dirs exist (ACLs applied later)
for d in "${DIRS[@]}"; do
  ensure_dir_root_users_2770 "$d"
done

UID_MIN="$(awk '$1=="UID_MIN"{print $2}' /etc/login.defs 2>/dev/null | tail -n1 || echo 1000)"

# Migrate + symlink per-user folders
while IFS=: read -r user _ uid gid _ home shell; do
  [[ "$uid" =~ ^[0-9]+$ ]] || continue
  (( uid >= UID_MIN && uid != 65534 )) || continue
  case "$shell" in */nologin|*/false) continue ;; esac
  [[ -d "$home" ]] || continue

  # If user is NOT in supplementary group "users":
  # - preserve old primary as supplementary unless it's the per-user group
  # - set primary group to "users"
  # - remove and delete per-user group (name == username) if empty + unused
  if ! id -nG "$user" 2>/dev/null | tr ' ' '\n' | grep -qx users; then
    pg="$(getent group "$gid" | cut -d: -f1)"

    [[ -n "$pg" && "$pg" != "$user" ]] && usermod -aG "$pg" "$user" || true
    usermod -g users "$user" || true

    if getent group "$user" >/dev/null; then
      gpasswd -d "$user" "$user" >/dev/null 2>&1 || true
      ugid="$(getent group "$user" | cut -d: -f3)"
      [[ -z "$(getent group "$user" | cut -d: -f4)" ]] &&
      ! getent passwd | awk -F: -v g="$ugid" '$4==g{exit 1}' &&
      groupdel "$user" || true
    fi
  fi

  ts="$(date +%Y%m%d-%H%M%S)"
  overflow="/home/Shared/$user-$ts"

  for folder in "${USER_FOLDERS[@]}"; do
    src="$home/$folder"
    dest="/home/Shared/$folder/$user"
    mkdir -p "$dest"

    # Missing -> symlink
    if [[ ! -e "$src" ]]; then
      ln -s "$dest" "$src"
      continue
    fi

    # Symlink -> ensure correct target (broken-safe)
    if [[ -L "$src" ]]; then
      link="$(readlink -f -- "$src" 2>/dev/null || true)"
      [[ "$link" == "$dest" ]] || { rm -f -- "$src"; ln -s "$dest" "$src"; }
      continue
    fi

    # Directory -> merge without overwrite; leftovers -> single overflow; then symlink
    if [[ -d "$src" ]]; then
      # Safety: never rm -rf a mountpoint directory
      if mountpoint -q "$src"; then
        mkdir -p "$overflow"
        mv -- "$src" "$overflow/${folder}.mountpoint" 2>/dev/null || true
        ln -s "$dest" "$src"
        continue
      fi

      rsync -a --ignore-existing --remove-source-files -- "$src"/ "$dest"/
      find "$src" -type d -empty -delete

      if [[ -n "$(ls -A -- "$src" 2>/dev/null)" ]]; then
        mkdir -p "$overflow/$folder"
        rsync -a --remove-source-files -- "$src"/ "$overflow/$folder"/
        find "$src" -type d -empty -delete
      fi

      rm -rf -- "$src"
      ln -s "$dest" "$src"
      continue
    fi

    # Other type -> move to overflow; symlink
    mkdir -p "$overflow/$folder"
    mv -n -- "$src" "$overflow/$folder"/ 2>/dev/null || mv -- "$src" "$overflow/$folder"/
    ln -s "$dest" "$src"
  done

  # Remove overflow if nothing ended up there
  rmdir --ignore-fail-on-non-empty "$overflow" 2>/dev/null || true
done < <(getent passwd)

# Permissions / ACL enforcement for shared dirs
for d in "${DIRS[@]}"; do
  set_acl_tree_users_rwx "$d"
done

# Flatpak overrides (keep as-is)
flatpaks=$(flatpak list --columns=application)
for flatpak in $flatpaks; do
  if [ "$(flatpak info --show-permissions "$flatpak" | grep -c "home;")" -gt 0 ]; then
    flatpak override \
      --filesystem=/home/Shared \
      --filesystem=/home/Node \
      --filesystem=/home/Git \
      --filesystem=/home/Trash \
      --filesystem=/home/Storage \
      "$flatpak"
  fi
done
