#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

WALLPAPER="/usr/share/backgrounds/aurora/jonatan-pie-aurora/contents/images/3944x2770.jxl"

# Allow KDE polkit agent to autostart in LXQt.
for file in \
  /usr/share/applications/org.kde.polkit-kde-authentication-agent-1.desktop \
  /usr/etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop \
  /etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop
do
  [[ -f "$file" ]] && sed -i 's/^OnlyShowIn=.*/OnlyShowIn=KDE;LXQt;XFCE;/' "$file"
done

mkdir -p \
  /usr/sbin \
  /usr/share/xsessions \
  /etc/sddm.conf.d \
  /etc/skel/.config/lxqt \
  /etc/skel/.config/gtk-3.0 \
  /etc/skel/.config/gtk-4.0 \
  /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml \
  /etc/skel/.icons/default \
  /usr/etc/xdg/lxqt \
  /usr/etc/xdg/gtk-3.0 \
  /usr/etc/xdg/gtk-4.0 \
  /usr/share/icons/default

cat > /etc/skel/.config/lxqt/lxqt.conf <<'EOF_LXQT'
[General]
icon_theme=breeze-dark
theme=KDE-Plasma
single_click_activate=false

[Qt]
style=Breeze
font="Noto Sans,10,-1,5,50,0,0,0,0,0"
EOF_LXQT
cp /etc/skel/.config/lxqt/lxqt.conf /usr/etc/xdg/lxqt/lxqt.conf

cat > /etc/skel/.config/lxqt/lxqt-config-appearance.conf <<'EOF_LXQT_APPEARANCE'
[GTK]
sNet/ThemeName=Breeze
sNet/IconThemeName=breeze-dark
sGtk/FontName=Noto Sans 10
EOF_LXQT_APPEARANCE
cp /etc/skel/.config/lxqt/lxqt-config-appearance.conf /usr/etc/xdg/lxqt/lxqt-config-appearance.conf

cat > /etc/skel/.config/gtk-3.0/settings.ini <<'EOF_GTK'
[Settings]
gtk-theme-name=Breeze
gtk-icon-theme-name=breeze-dark
gtk-cursor-theme-name=breeze_cursors
gtk-font-name=Noto Sans 10
gtk-application-prefer-dark-theme=1
EOF_GTK
cp /etc/skel/.config/gtk-3.0/settings.ini /usr/etc/xdg/gtk-3.0/settings.ini
cp /etc/skel/.config/gtk-3.0/settings.ini /etc/skel/.config/gtk-4.0/settings.ini
cp /etc/skel/.config/gtk-3.0/settings.ini /usr/etc/xdg/gtk-4.0/settings.ini

cat > /etc/skel/.icons/default/index.theme <<'EOF_CURSOR'
[Icon Theme]
Inherits=breeze_cursors,breeze-dark
EOF_CURSOR
cp /etc/skel/.icons/default/index.theme /usr/share/icons/default/index.theme

cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml <<'EOF_XFWM4'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Breeze"/>
    <property name="title_font" type="string" value="Noto Sans 10"/>
    <property name="use_compositing" type="bool" value="true"/>
  </property>
</channel>
EOF_XFWM4

cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml <<'EOF_XSETTINGS'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Breeze"/>
    <property name="IconThemeName" type="string" value="breeze-dark"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="FontName" type="string" value="Noto Sans 10"/>
    <property name="CursorThemeName" type="string" value="breeze_cursors"/>
    <property name="CursorThemeSize" type="int" value="24"/>
  </property>
</channel>
EOF_XSETTINGS

cat > /usr/sbin/start-lxqt.sh <<EOF_START
#!/usr/bin/env bash
set +e

mkdir -p "\$HOME/.cache"
exec >"\$HOME/.cache/lxqt-session.log" 2>&1

export DESKTOP_SESSION=lxqt
export XDG_CURRENT_DESKTOP=LXQt
export XDG_SESSION_DESKTOP=lxqt
export QT_QPA_PLATFORM=xcb
export QT_QPA_PLATFORMTHEME=lxqt
export XCURSOR_THEME=breeze_cursors
export XCURSOR_SIZE=24

dbus-update-activation-environment --systemd \
  DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP \
  QT_QPA_PLATFORM QT_QPA_PLATFORMTHEME XCURSOR_THEME XCURSOR_SIZE \
  2>/dev/null || true

seed_file() {
  [[ -f "\$2" || ! -f "\$1" ]] && return 0
  mkdir -p "\$(dirname "\$2")"
  cp "\$1" "\$2"
}

seed_file /etc/skel/.config/lxqt/lxqt.conf "\$HOME/.config/lxqt/lxqt.conf"
seed_file /etc/skel/.config/lxqt/lxqt-config-appearance.conf "\$HOME/.config/lxqt/lxqt-config-appearance.conf"
seed_file /etc/skel/.config/gtk-3.0/settings.ini "\$HOME/.config/gtk-3.0/settings.ini"
seed_file /etc/skel/.config/gtk-4.0/settings.ini "\$HOME/.config/gtk-4.0/settings.ini"
seed_file /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml "\$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
seed_file /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml "\$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
seed_file /etc/skel/.icons/default/index.theme "\$HOME/.icons/default/index.theme"

xfsettingsd &
feh --bg-fill "$WALLPAPER" &
lxqt-globalkeysd &
lxqt-notificationd &
lxqt-powermanagement &
lxqt-panel &
nm-applet &

exec xfwm4 --replace
EOF_START
chmod a+x /usr/sbin/start-lxqt.sh

cat > /usr/share/xsessions/lxqt.desktop <<'EOF_SESSION'
[Desktop Entry]
Name=LXQt
Comment=LXQt desktop session
Exec=/usr/sbin/start-lxqt.sh
Type=Application
DesktopNames=LXQt
EOF_SESSION

cat > /etc/sddm.conf.d/10-x11.conf <<'EOF_SDDM'
[General]
DisplayServer=x11
GreeterEnvironment=QT_QPA_PLATFORM=xcb,QT_QPA_PLATFORMTHEME=lxqt,XCURSOR_THEME=breeze_cursors,XCURSOR_SIZE=24
InputMethod=
EOF_SDDM

gtk-update-icon-cache -f /usr/share/icons/hicolor >/dev/null 2>&1 || true
