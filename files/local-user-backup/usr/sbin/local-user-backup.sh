#!/usr/bin/env bash
set -euo pipefail
umask 077

DIR=/var/lib/local-user-backup
FILE=$DIR/users
LOCK=$DIR/users.lock
MIN=1000
MAX=60000

log(){ echo "local-user-backup: $*"; }
warn(){ echo "local-user-backup: WARNING: $*" >&2; }
die(){ echo "local-user-backup: ERROR: $*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "run as root"

install -d -o root -g root -m 0700 "$DIR"
[[ -e "$FILE" ]] || install -o root -g root -m 0600 /dev/null "$FILE"
[[ ! -L "$FILE" ]] || die "refusing symlink: $FILE"
[[ "$(stat -c '%U:%G %a' "$FILE")" == "root:root 600" ]] || die "$FILE must be root:root 600"

exec 9>"$LOCK"
flock -x 9

ok_type(){ [[ "$1" == required || "$1" == recover || "$1" == ignore ]]; }
ok_name(){ [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]; }
ok_num(){ [[ "$1" =~ ^[0-9]+$ ]]; }
ok_home(){ [[ "$2" == "/home/$1" ]]; }
ok_groups(){ [[ -z "$1" || "$1" =~ ^[A-Za-z0-9_,.-]+$ ]]; }
ok_hash(){ [[ -z "$1" || "$1" == "!" || "$1" == "!!" || "$1" == "*" || "$1" =~ ^\$[A-Za-z0-9]+\$ ]]; }
ok_shell(){ [[ -x "$1" ]] && { [[ ! -f /etc/shells ]] || grep -qxF "$1" /etc/shells; }; }
clean(){ printf '%s' "$1" | tr ':\r\n' '   '; }

validate(){
  ok_type "$1" || die "$9: bad type"
  ok_name "$2" || die "$9: bad username"
  ok_num "$3" && ok_num "$4" || die "$9: bad uid/gid"
  (( $3 >= MIN && $3 <= MAX )) || die "$9: uid out of range"
  ok_name "$5" || die "$9: bad primary group"
  ok_home "$2" "$6" || die "$9: home must be /home/$2"
  ok_groups "$7" || die "$9: bad groups"
  ok_hash "$8" || die "$9: bad hash"
}

backup_changed(){
  [[ -f "$1" ]] || return 0
  [[ -f "$2" ]] && cmp -s "$1" "$2" && return 0
  [[ -f "$2" ]] && install -o root -g root -m 0600 "$2" "$2.previous"
  install -o root -g root -m 0600 "$1" "$2"
}

backup_changed /etc/subuid "$DIR/subuid"
backup_changed /etc/subgid "$DIR/subgid"

TYPES=$(mktemp "$DIR/.types.XXXXXX")
NEW=$(mktemp "$DIR/.users.XXXXXX")
trap 'rm -f "$TYPES" "$NEW"' EXIT
chmod 0600 "$TYPES" "$NEW"

# Existing manifest: validate it and remember user types.
if [[ -s "$FILE" ]]; then
  n=0
  while IFS=: read -r t u uid gid pg gecos home shell groups hash extra; do
    n=$((n+1))
    [[ -n "${t:-}" ]] || die "blank line $n"
    [[ -z "${extra:-}" ]] || die "too many fields line $n"

    home=${home:-/home/$u}
    shell=${shell:-/bin/bash}
    groups=${groups:-}
    hash=${hash:-}

    validate "$t" "$u" "$uid" "$gid" "$pg" "$home" "$groups" "$hash" "line $n"

    grep -q "^$u:" "$TYPES" && die "duplicate user $u line $n"
    printf '%s:%s\n' "$u" "$t" >> "$TYPES"
  done < "$FILE"
fi

type_for(){
  local t
  t=$(grep -m1 "^$1:" "$TYPES" | cut -d: -f2 || true)
  printf '%s\n' "${t:-recover}"
}

# Current local users become the fresh manifest.
while IFS=: read -r u _ uid gid gecos home shell; do
  ok_num "$uid" || continue
  (( uid >= MIN && uid <= MAX )) || continue
  ok_name "$u" || continue
  ok_home "$u" "$home" || { warn "skip $u: home=$home"; continue; }

  pg=$(getent group "$gid" | cut -d: -f1 || true)
  [[ -n "$pg" ]] && ok_name "$pg" || { warn "skip $u: bad primary group"; continue; }

  t=$(type_for "$u")
  groups=$(id -nG "$u" | tr ' ' '\n' | grep -vxF "$pg" | paste -sd, - || true)
  hash=$(getent shadow "$u" | cut -d: -f2 || true)

  ok_hash "$hash" || { warn "skip $u: bad hash"; continue; }

  printf '%s:%s:%s:%s:%s:%s:%s:%s:%s:%s\n' \
    "$t" "$u" "$uid" "$gid" "$pg" "$(clean "$gecos")" "$home" "$(clean "$shell")" "$groups" "$hash" >> "$NEW"
done < /etc/passwd

# Preserve missing old entries.
if [[ -s "$FILE" ]]; then
  while IFS=: read -r t u uid gid pg gecos home shell groups hash extra; do
    grep -qE "^[^:]+:$u:" "$NEW" && continue

    home=${home:-/home/$u}
    shell=${shell:-/bin/bash}
    groups=${groups:-}
    hash=${hash:-}

    printf '%s:%s:%s:%s:%s:%s:%s:%s:%s:%s\n' \
      "$t" "$u" "$uid" "$gid" "$pg" "$(clean "$gecos")" "$home" "$(clean "$shell")" "$groups" "$hash" >> "$NEW"
  done < "$FILE"
fi

# Validate and install manifest atomically.
while IFS=: read -r t u uid gid pg gecos home shell groups hash extra; do
  [[ -z "${extra:-}" ]] || die "generated malformed line for $u"
  validate "$t" "$u" "$uid" "$gid" "$pg" "$home" "$groups" "$hash" "generated $u"
done < "$NEW"

sync -f "$NEW"
mv -f "$NEW" "$FILE"
chown root:root "$FILE"
chmod 0600 "$FILE"
sync -f "$DIR"

pwck -r || warn "pwck reported issues before restore"
grpck -r || warn "grpck reported issues before restore"

# Restore missing users.
while IFS=: read -r t u uid gid pg gecos home shell groups hash extra; do
  id "$u" >/dev/null 2>&1 && continue

  [[ "$t" != ignore ]] || {
    log "skip ignore:$u"
    continue
  }

  [[ "$t" != recover || -d "$home" ]] || {
    log "skip recover:$u home missing"
    continue
  }

  [[ "$t" != required || -d "$home" ]] || {
    log "required:$u home missing; creating it"
  }

  ok_shell "$shell" || shell=/bin/bash
  ok_shell "$shell" || {
    warn "$u: no valid shell"
    continue
  }

  if [[ -e "$home" ]]; then
    [[ -d "$home" ]] || {
      warn "$u: $home is not a directory"
      continue
    }

    [[ "$(stat -c '%u:%g' "$home")" == "$uid:$gid" ]] || {
      warn "$u: $home ownership mismatch"
      continue
    }
  fi

  getent passwd "$uid" >/dev/null && {
    warn "$u: uid $uid already used"
    continue
  }

  if getent group "$pg" >/dev/null; then
    [[ "$(getent group "$pg" | cut -d: -f3)" == "$gid" ]] || {
      warn "$u: group $pg gid mismatch"
      continue
    }
  else
    getent group "$gid" >/dev/null && {
      warn "$u: gid $gid already used"
      continue
    }

    groupadd --gid "$gid" "$pg"
  fi

  args=(
    --uid "$uid"
    --gid "$gid"
    --comment "$gecos"
    --home-dir "$home"
    --create-home
    --shell "$shell"
  )

  if [[ -n "$groups" ]]; then
    valid=()
    IFS=',' read -ra arr <<< "$groups"

    for g in "${arr[@]}"; do
      [[ -n "$g" ]] || continue

      if getent group "$g" >/dev/null; then
        valid+=("$g")
      else
        warn "$u: missing group $g"
      fi
    done

    (( ${#valid[@]} )) && args+=(--groups "$(IFS=,; echo "${valid[*]}")")
  fi

  [[ -z "$hash" || "$hash" == "!" || "$hash" == "!!" || "$hash" == "*" ]] || args+=(--password "$hash")

  useradd "${args[@]}" "$u"

  [[ -z "$hash" || "$hash" == "!" || "$hash" == "!!" || "$hash" == "*" ]] && passwd -l "$u" >/dev/null

  log "created:$u"
done < "$FILE"

log "complete"
