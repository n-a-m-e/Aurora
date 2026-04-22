#!/usr/bin/env bash
set -oue pipefail

mkdir -p /usr/etc/xdg

cat <<'EOF' > /usr/etc/xdg/powerdevilrc
[AC][SuspendAndShutdown]
AutoSuspendAction=0
EOF

cat <<'EOF' > /usr/etc/xdg/kscreenlockerrc
[Daemon]
Autolock=false
LockOnResume=false
EOF

touch /usr/etc/xdg/plasmanotifyrc

cat <<'EOF' >> /usr/etc/xdg/plasmanotifyrc

[Applications][printmanager]
ShowPopups=false
ShowInHistory=false
EOF
