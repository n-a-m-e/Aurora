#!/usr/bin/env bash
set -oue pipefail

install -d -m 0755 /usr/lib/sysusers.d

cat <<'EOF' > /usr/lib/sysusers.d/thinclient.conf
u thinclient 1001 "Thin Client Session User" /var/home/thinclient /bin/bash
u greeter 1002 "Greetd Greeter User" /var/lib/greeter /sbin/nologin

# Local override because Fedora/systemd-userdb may expose video dynamically
# without a writable /etc/group entry. Xorg may need this for /dev/dri/card0.
g video 39
m thinclient video
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
d /var/lib/greeter 0750 greeter greeter -
d /var/home/thinclient 0750 thinclient thinclient -
EOF

# IceWM system config
mkdir -p /etc/icewm

cat >/etc/icewm/toolbar <<'EOF'
prog "ThinLinc" - /opt/thinlinc/bin/tlclient
prog "Moonlight" - moonlight-qt
prog "Terminal" - xterm -fa Monospace -fs 12
EOF

cat >/etc/icewm/menu <<'EOF'
prog "ThinLinc" - /opt/thinlinc/bin/tlclient
prog "Moonlight" - moonlight-qt
prog "Terminal" - xterm -fa Monospace -fs 12
separator
prog "Reboot" - systemctl reboot
prog "Power Off" - systemctl poweroff
EOF

cat >/etc/icewm/preferences <<'EOF'
TaskBarAtTop=0
TaskBarAutoHide=0
TaskBarShowClock=1
TaskBarShowAPMStatus=0
TaskBarShowMailboxStatus=0
TaskBarShowWorkspaces=0
TaskBarShowWindows=1
TaskBarShowStartMenu=1
TaskBarShowWindowListMenu=0
TaskBarShowShowDesktopButton=0
TaskBarShowTray=1
ShowTaskBar=1
DesktopBackgroundCenter=0
DesktopBackgroundScaled=1
FocusMode=1
ClickToFocus=1
RaiseOnFocus=1
EOF

# greetd config
mkdir -p /usr/etc/greetd
cat >/usr/etc/greetd/config.toml <<'EOF'
[terminal]
vt = 1

[default_session]
command = "startx /usr/sbin/thinclient-session.sh -- :0 vt1 -nolisten tcp"
user = "thinclient"

[initial_session]
command = "startx /usr/sbin/thinclient-session.sh -- :0 vt1 -nolisten tcp"
user = "thinclient"
EOF
