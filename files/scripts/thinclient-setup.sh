#!/usr/bin/env bash
set -oue pipefail

THINCLIENT_USER="thinclient"
THINCLIENT_HOME="/var/home/${THINCLIENT_USER}"

# Ensure thinclient user exists
if ! getent passwd "${THINCLIENT_USER}" >/dev/null 2>&1; then
  EXTRA_GROUPS=()

  for grp in video input audio wheel; do
    if getent group "${grp}" >/dev/null 2>&1; then
      EXTRA_GROUPS+=("${grp}")
    fi
  done

  if [ "${#EXTRA_GROUPS[@]}" -gt 0 ]; then
    useradd \
      --create-home \
      --home-dir "${THINCLIENT_HOME}" \
      --groups "$(IFS=,; echo "${EXTRA_GROUPS[*]}")" \
      --shell /bin/bash \
      "${THINCLIENT_USER}"
  else
    useradd \
      --create-home \
      --home-dir "${THINCLIENT_HOME}" \
      --shell /bin/bash \
      "${THINCLIENT_USER}"
  fi
fi

# ThinLinc defaults
if [ -f /opt/thinlinc/etc/tlclient.conf ]; then
  sed -i 's|^FULL_SCREEN_MODE=.*|FULL_SCREEN_MODE=1|' /opt/thinlinc/etc/tlclient.conf || true
fi

# ThinLinc runtime paths for bootc/immutable systems
mkdir -p /usr/lib/tmpfiles.d
cat >/usr/lib/tmpfiles.d/thinlinc-client.conf <<'EOF'
d /var/opt/thinlinc 0755 root root -
L+ /var/opt/thinlinc/lib - - - - /usr/lib/opt/thinlinc/lib
L+ /var/opt/thinlinc/etc - - - - /usr/lib/opt/thinlinc/etc
L+ /var/opt/thinlinc/bin - - - - /usr/lib/opt/thinlinc/bin
EOF

# greetd config
mkdir -p /usr/etc/greetd
cat >/usr/etc/greetd/config.toml <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --cmd 'sh -lc \"/usr/libexec/thinclient-menu & exec labwc -s /opt/thinlinc/bin/tlclient\"'"
user = "greeter"

[initial_session]
command = "sh -lc '/usr/libexec/thinclient-menu & exec labwc -s /opt/thinlinc/bin/tlclient'"
user = "${THINCLIENT_USER}"
EOF

# tiny launcher menu
mkdir -p /usr/libexec
cat >/usr/libexec/thinclient-menu <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

while true; do
  choice="$(
    printf "ThinLinc\nMoonlight\nTerminal\n" |
      fuzzel --dmenu --prompt "Session " --lines 3 --width 24 2>/dev/null || true
  )"

  case "${choice:-}" in
    ThinLinc)
      /opt/thinlinc/bin/tlclient &
      ;;
    Moonlight)
      moonlight-qt &
      ;;
    Terminal)
      foot &
      ;;
  esac

  sleep 1
done
EOF

chmod 0755 /usr/libexec/thinclient-menu
