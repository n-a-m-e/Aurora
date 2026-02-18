#!/bin/bash
set -euo pipefail

# Prevent overlapping runs
exec 9>/run/shared-folder.lock
flock -n 9 || exit 0

umask 002

DIRS=(/home/Shared /home/Node /home/Git /home/Trash /home/Storage /home/Secrets)
USER_FOLDERS=(Desktop Documents Downloads Music Pictures Videos)

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

# Ensure top dirs exist (ACLs applied later)
for DIR in "${DIRS[@]}"; do
  mkdir -p "$DIR"
  chown root:users "$DIR"
  chmod 2770 "$DIR"
done

UID_MIN="$(awk '$1=="UID_MIN"{print $2}' /etc/login.defs 2>/dev/null | tail -n1 || echo 1000)"

# Migrate + symlink per-user folders
while IFS=: read -r user _ uid _ _ home shell; do
  [[ "$uid" =~ ^[0-9]+$ ]] || continue
  (( uid >= UID_MIN && uid != 65534 )) || continue
  case "$shell" in */nologin|*/false) continue ;; esac
  [[ -d "$home" ]] || continue

  # Only add to group if not already in it
  if ! id -nG "$user" 2>/dev/null | grep -qw users; then
    usermod -aG users "$user" || true
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

# Permissions / ACL enforcement
for DIR in "${DIRS[@]}"; do
  if (( FULL )); then
    setfacl -Rb "$DIR"
  fi

  setfacl -m  u::rwx,g::rwx,o::--- "$DIR"
  setfacl -d -m u::rwx,g::rwx,o::--- "$DIR"

  if (( FULL )); then
    chgrp -R users "$DIR"
    chmod -R g+rwX,o-rwx "$DIR"
    find "$DIR" -type d \
      -exec chmod g+s,o-rwx {} + \
      -exec setfacl -m u::rwx,g::rwx,o::--- {} + \
      -exec setfacl -d -m u::rwx,g::rwx,o::--- {} +
  else
    find "$DIR" "${FIND_MMIN[@]}" -exec chgrp users {} + -exec chmod g+rwX,o-rwx {} +
    find "$DIR" -type d "${FIND_MMIN[@]}" \
      -exec chmod g+s,o-rwx {} + \
      -exec setfacl -m u::rwx,g::rwx,o::--- {} + \
      -exec setfacl -d -m u::rwx,g::rwx,o::--- {} +
  fi
done

flatpaks=$(flatpak list --columns=application)
for flatpak in $flatpaks; do
    if [ $(flatpak info --show-permissions $flatpak| grep -c "home;") -gt 0 ]; then
        flatpak override --filesystem=/home/Shared --filesystem=/home/Node --filesystem=/home/Git --filesystem=/home/Trash --filesystem=/home/Storage $flatpak
    fi
done
