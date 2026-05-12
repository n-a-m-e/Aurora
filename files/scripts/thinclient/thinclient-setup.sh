#!/usr/bin/env bash
set -oue pipefail

install -d -m 0755 /usr/lib/sysusers.d

cat <<'EOF' > /usr/lib/sysusers.d/thinclient.conf
u thinclient 1001 "Thin Client Session User" /var/home/thinclient /bin/bash
u greeter 1002 "Greetd Greeter User" /var/lib/greeter /sbin/nologin
EOF

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

cat >/usr/lib/tmpfiles.d/thinclient.conf <<'EOF'
d /var/lib/greeter 0750 greeter greeter -
d /var/home/thinclient 0750 thinclient thinclient -
EOF

# greetd config
mkdir -p /usr/etc/greetd
cat >/usr/etc/greetd/config.toml <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --cmd 'sh -lc \"/usr/sbin/thinclient-menu.sh & exec labwc -s /opt/thinlinc/bin/tlclient\"'"
user = "greeter"

[initial_session]
command = "sh -lc '/usr/sbin/thinclient-menu.sh & exec labwc -s /opt/thinlinc/bin/tlclient'"
user = "thinclient"
EOF
