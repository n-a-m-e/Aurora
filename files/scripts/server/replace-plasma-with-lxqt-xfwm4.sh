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
    sed -i 's/^OnlyShowIn=.*/OnlyShowIn=KDE;LXQt;/' "$file"
  fi
done

# Configure SDDM for an X11 greeter/session path.
# In BlueBuild/rpm-ostree images, write system defaults to /etc during build;
# rpm-ostree will deploy them appropriately.
mkdir -p /usr/local/bin /usr/share/xsessions /etc/sddm.conf.d /etc/skel/.config/variety

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

cat > /usr/local/bin/start-xfwm4-lxqt <<'EOF'
#!/usr/bin/env bash
set +e

export DESKTOP_SESSION=xfwm4-lxqt
export XDG_CURRENT_DESKTOP=LXQt
export XDG_SESSION_DESKTOP=xfwm4-lxqt
export QT_QPA_PLATFORM=xcb

dbus-update-activation-environment --systemd \
  DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP \
  2>/dev/null

if [ ! -f "$HOME/.config/variety/variety.conf" ]; then
  mkdir -p "$HOME/.config/variety"
  cp /etc/skel/.config/variety/variety.conf "$HOME/.config/variety/variety.conf"
fi

xfsettingsd &
xfwm4 --replace &
variety &
lxqt-globalkeysd &
lxqt-notificationd &
lxqt-powermanagement &
lxqt-panel &
nm-applet &

wait
EOF

chmod +x /usr/local/bin/start-xfwm4-lxqt

rm -f /usr/share/xsessions/lxqt.desktop \
      /usr/share/xsessions/openbox.desktop \
      /usr/share/wayland-sessions/*.desktop

cat > /usr/share/xsessions/xfwm4-lxqt.desktop <<'EOF'
[Desktop Entry]
Name=xfwm4 LXQt
Exec=/usr/local/bin/start-xfwm4-lxqt
Type=Application
DesktopNames=LXQt
EOF

cat > /etc/sddm.conf.d/10-x11.conf <<'EOF'
[General]
DisplayServer=x11
GreeterEnvironment=QT_QPA_PLATFORM=xcb
EOF
