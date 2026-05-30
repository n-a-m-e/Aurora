#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

WALLPAPER="/usr/share/backgrounds/aurora/jonatan-pie-aurora/contents/images/3944x2770.jxl"
LXQT_THEME="Dark-Breeze"
CURSOR_THEME="breeze_cursors"
CURSOR_SIZE="24"
DARK_BREEZE_URL="https://github.com/n-a-m-e/Aurora-Files/releases/download/Dark_Breeze_by_Nudnik/Dark_Breeze_by_Nudnik.tar.gz"

# Allow KDE polkit agent to autostart in LXQt.
for file in \
  /usr/share/applications/org.kde.polkit-kde-authentication-agent-1.desktop \
  /usr/etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop \
  /etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop
do
  [[ -f "$file" ]] && sed -i 's/^OnlyShowIn=.*/OnlyShowIn=KDE;LXQt;XFCE;/' "$file"
done

install_dark_breeze_lxqt_theme() {
  mkdir -p /usr/share/lxqt/themes

  local workdir archive found
  workdir="$(mktemp -d)"
  archive="${workdir}/Dark_Breeze_by_Nudnik.tar.gz"

  cleanup_dark_breeze_tmp() { rm -rf "$workdir"; }
  trap cleanup_dark_breeze_tmp RETURN

  echo "Downloading Dark Breeze by Nudnik LXQt theme..."
  curl -fL --retry 3 --retry-delay 2 \
    -H 'User-Agent: Mozilla/5.0' \
    "${DARK_BREEZE_URL}" \
    -o "$archive"

  mkdir -p "${workdir}/extract"
  tar -xzf "$archive" -C "${workdir}/extract"

  found="$(find "${workdir}/extract" -type f -name 'lxqt-panel.qss' -printf '%h\n' | head -n1)"
  if [[ -z "$found" ]]; then
    echo "Dark Breeze archive did not contain lxqt-panel.qss" >&2
    return 1
  fi

  rm -rf "/usr/share/lxqt/themes/${LXQT_THEME}"
  cp -a "$found" "/usr/share/lxqt/themes/${LXQT_THEME}"
}
install_dark_breeze_lxqt_theme

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

cat > /etc/skel/.config/lxqt/lxqt.conf <<EOF_LXQT
[General]
icon_theme=breeze-dark
theme=${LXQT_THEME}
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

cat > /etc/skel/.config/lxqt/panel.conf <<'EOF_PANEL'
[General]
__userfile__=true
panels=panel1

[panel1]
alignment=0
animation-duration=0
desktop=0
hidable=false
lineCount=1
lockPanel=false
panelSize=40
plugins=mainmenu,quicklaunch,taskbar,statusnotifier,tray,volume,clock
position=Bottom
reserve-space=true
show-delay=0
type=panel
width=100
width-percent=true

[mainmenu]
alignment=Left
icon=distributor-logo
type=mainmenu

[quicklaunch]
alignment=Left
apps\1\desktop=/var/lib/flatpak/exports/share/applications/org.mozilla.firefox.desktop
apps\2\desktop=/usr/share/applications/org.kde.dolphin.desktop
apps\3\desktop=/usr/share/applications/org.kde.yakuake.desktop
apps\4\desktop=/usr/share/applications/org.kde.kate.desktop
apps\size=4
type=quicklaunch

[taskbar]
alignment=Left
type=taskbar

[statusnotifier]
alignment=Right
type=statusnotifier

[tray]
alignment=Right
type=tray

[volume]
alignment=Right
type=volume

[clock]
alignment=Right
type=clock
EOF_PANEL
cp /etc/skel/.config/lxqt/panel.conf /usr/etc/xdg/lxqt/panel.conf

cat > /etc/skel/.config/gtk-3.0/settings.ini <<EOF_GTK
[Settings]
gtk-theme-name=Breeze
gtk-icon-theme-name=breeze-dark
gtk-cursor-theme-name=${CURSOR_THEME}
gtk-cursor-theme-size=${CURSOR_SIZE}
gtk-font-name=Noto Sans 10
gtk-application-prefer-dark-theme=1
EOF_GTK
cp /etc/skel/.config/gtk-3.0/settings.ini /usr/etc/xdg/gtk-3.0/settings.ini
cp /etc/skel/.config/gtk-3.0/settings.ini /etc/skel/.config/gtk-4.0/settings.ini
cp /etc/skel/.config/gtk-3.0/settings.ini /usr/etc/xdg/gtk-4.0/settings.ini

cat > /etc/skel/.icons/default/index.theme <<EOF_CURSOR
[Icon Theme]
Inherits=${CURSOR_THEME}
EOF_CURSOR
cp /etc/skel/.icons/default/index.theme /usr/share/icons/default/index.theme

cat > /etc/skel/.Xresources <<EOF_XRESOURCES
Xcursor.theme: ${CURSOR_THEME}
Xcursor.size: ${CURSOR_SIZE}
EOF_XRESOURCES

cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml <<'EOF_XFWM4'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Breeze"/>
    <property name="title_font" type="string" value="Noto Sans 10"/>
    <property name="button_layout" type="string" value="O|HMC"/>
    <property name="use_compositing" type="bool" value="true"/>
    <property name="workspace_count" type="int" value="1"/>
    <property name="tile_on_move" type="bool" value="true"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="true"/>
    <property name="snap_width" type="int" value="10"/>
    <property name="wrap_windows" type="bool" value="false"/>
    <property name="wrap_workspaces" type="bool" value="false"/>
  </property>
</channel>
EOF_XFWM4

cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml <<EOF_XSETTINGS
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Breeze"/>
    <property name="IconThemeName" type="string" value="breeze-dark"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="FontName" type="string" value="Noto Sans 10"/>
    <property name="CursorThemeName" type="string" value="${CURSOR_THEME}"/>
    <property name="CursorThemeSize" type="int" value="${CURSOR_SIZE}"/>
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
export XCURSOR_THEME=${CURSOR_THEME}
export XCURSOR_SIZE=${CURSOR_SIZE}

xrdb -merge "\$HOME/.Xresources" 2>/dev/null || xrdb -merge /etc/skel/.Xresources 2>/dev/null || true

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
seed_file /etc/skel/.config/lxqt/panel.conf "\$HOME/.config/lxqt/panel.conf"
seed_file /etc/skel/.config/gtk-3.0/settings.ini "\$HOME/.config/gtk-3.0/settings.ini"
seed_file /etc/skel/.config/gtk-4.0/settings.ini "\$HOME/.config/gtk-4.0/settings.ini"
seed_file /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml "\$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
seed_file /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml "\$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
seed_file /etc/skel/.icons/default/index.theme "\$HOME/.icons/default/index.theme"
seed_file /etc/skel/.Xresources "\$HOME/.Xresources"

xfconf-query -c xfwm4 -p /general/workspace_count -s 1 --create -t int 2>/dev/null || true
xfconf-query -c xfwm4 -p /general/tile_on_move -s true --create -t bool 2>/dev/null || true
xfconf-query -c xfwm4 -p /general/wrap_windows -s false --create -t bool 2>/dev/null || true
xfconf-query -c xfwm4 -p /general/wrap_workspaces -s false --create -t bool 2>/dev/null || true

xfsettingsd &
feh --bg-fill "${WALLPAPER}" &
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

cat > /etc/sddm.conf.d/10-x11.conf <<EOF_SDDM
[General]
DisplayServer=x11
GreeterEnvironment=QT_QPA_PLATFORM=xcb,QT_QPA_PLATFORMTHEME=lxqt,XCURSOR_THEME=${CURSOR_THEME},XCURSOR_SIZE=${CURSOR_SIZE}
InputMethod=
EOF_SDDM

gtk-update-icon-cache -f /usr/share/icons/hicolor >/dev/null 2>&1 || true
