#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

# Allow KDE polkit agent to autostart in LXQt.
for file in \
  /usr/share/applications/org.kde.polkit-kde-authentication-agent-1.desktop \
  /usr/etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop
do
  if [[ -f "$file" ]]; then
    sed -i 's/^OnlyShowIn=.*/OnlyShowIn=KDE;LXQt;/' "$file"
  fi
done

# Make LXQt use xfwm4.
mkdir -p /usr/etc/xdg/lxqt

cat > /usr/etc/xdg/lxqt/session.conf <<'EOF'
[General]
window_manager=xfwm4
EOF
