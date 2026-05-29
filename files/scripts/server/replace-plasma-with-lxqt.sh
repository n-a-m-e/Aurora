#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

# Allow KDE polkit agent to autostart in LXQt as well as KDE.
# This lets us keep the KDE polkit agent instead of installing lxqt-policykit.
for file in \
  /usr/share/applications/org.kde.polkit-kde-authentication-agent-1.desktop \
  /usr/etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop \
  /etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop
do
  if [[ -f "$file" ]]; then
    sed -i 's/^OnlyShowIn=.*/OnlyShowIn=KDE;LXQt;XFCE;/' "$file"
  fi
done

# Configure custom X11 LXQt component session using xfwm4.
mkdir -p \
  /usr/local/bin \
  /usr/share/xsessions \
  /etc/sddm.conf.d \
  /etc/skel/.config/variety

cat > /etc/skel/.config/variety/variety.conf <<'EOF'
[config]
version = 80
change_enabled = True
change_interval = 300
download_enabled = False
safe_mode = True
favorites_operations = False
clock_enabled = False
quotes_enabled = False
slideshow_enabled = False
icon = Light
folder = /usr/share/backgrounds/aurora
folders = [['/usr/share/backgrounds/aurora', True]]
sources = [['album', '/usr/share/backgrounds/aurora', True]]
EOF

cat > /usr/local/bin/start-lxqt <<'EOF'
#!/usr/bin/env bash
set +e

mkdir -p "$HOME/.cache"
exec >"$HOME/.cache/lxqt-session.log" 2>&1

export DESKTOP_SESSION=lxqt
export XDG_CURRENT_DESKTOP=LXQt
export XDG_SESSION_DESKTOP=lxqt
export QT_QPA_PLATFORM=xcb

dbus-update-activation-environment --systemd \
  DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP \
  2>/dev/null || true

# Seed Variety config for users that do not have one yet.
if [ ! -f "$HOME/.config/variety/variety.conf" ] && [ -f /etc/skel/.config/variety/variety.conf ]; then
  mkdir -p "$HOME/.config/variety"
  cp /etc/skel/.config/variety/variety.conf "$HOME/.config/variety/variety.conf"
fi

xfsettingsd &
variety &
lxqt-globalkeysd &
lxqt-notificationd &
lxqt-powermanagement &
lxqt-panel &
nm-applet &

exec xfwm4 --replace
EOF

chmod +x /usr/local/bin/start-lxqt

cat > /usr/share/xsessions/lxqt.desktop <<'EOF'
[Desktop Entry]
Name=LXQt
Comment=LXQt desktop session
Exec=/usr/local/bin/start-lxqt
Type=Application
DesktopNames=LXQt
EOF

cat > /etc/sddm.conf.d/10-x11.conf <<'EOF'
[General]
DisplayServer=x11
GreeterEnvironment=QT_QPA_PLATFORM=xcb
InputMethod=
EOF
