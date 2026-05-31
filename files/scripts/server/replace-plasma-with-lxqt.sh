#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

WALLPAPER="/usr/share/backgrounds/aurora/jonatan-pie-aurora/contents/images/3944x2770.jxl"
LXQT_THEME="Dark-Breeze"
CURSOR_THEME="breeze_cursors"
CURSOR_SIZE="24"
MANAGED_LXQT_CONFIG_VERSION="2026-05-31-4"
REMOTE_SHUTDOWN="/usr/sbin/remote-shutdown.py"
DARK_BREEZE_URL="https://github.com/n-a-m-e/Aurora-Files/releases/download/Dark_Breeze_by_Nudnik/Dark_Breeze_by_Nudnik.tar.gz"
WINGMENU_URL="https://github.com/elviosak/plugin-wingmenu/archive/refs/heads/master.tar.gz"
WINGMENU_BUILD_DEPS=(
  cmake
  gcc-c++
  glib2-devel
  lxqt-build-tools
  lxqt-panel-devel
  liblxqt-devel
  lxqt-globalkeys-devel
  libqtxdg-devel
  qt6-qtbase-devel
  qt6-linguist
  qt6-qttools-devel
  kf6-kwindowsystem-devel
  qt6-qtbase-private-devel
)

install_wingmenu_build_deps() {
  echo "Installing temporary WingMenu build dependencies..."
  rpm-ostree install --idempotent "${WINGMENU_BUILD_DEPS[@]}"
}

remove_wingmenu_build_deps() {
  # Do not uninstall these here. Some devel packages pull in shared RPM macro/data
  # packages that remain required by other installed build artifacts, and rpm-ostree
  # can fail the whole build while trying to depsolve the removal transaction.
  # Keep the install/build path deterministic; clean-up should be handled by a
  # separate layer/squash strategy if needed.
  true
}

# Allow KDE polkit agent to autostart in LXQt.
for file in \
  /usr/share/applications/org.kde.polkit-kde-authentication-agent-1.desktop \
  /usr/etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop \
  /etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop
do
  [[ -f "$file" ]] && sed -i 's/^OnlyShowIn=.*/OnlyShowIn=KDE;LXQt;XFCE;/' "$file"
done

install_lxqt_runtime_deps() {
  rpm-ostree install --idempotent lxqt-session
}

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

install_wingmenu_plugin() {
  local workdir archive srcdir
  workdir="$(mktemp -d)"
  archive="${workdir}/plugin-wingmenu.tar.gz"

  cleanup_wingmenu_tmp() { rm -rf "$workdir"; }
  trap cleanup_wingmenu_tmp RETURN

  echo "Downloading and building LXQt WingMenu plugin..."
  curl -fL --retry 3 --retry-delay 2 \
    -H 'User-Agent: Mozilla/5.0' \
    "${WINGMENU_URL}" \
    -o "$archive"

  tar -xzf "$archive" -C "$workdir"
  srcdir="$(find "$workdir" -maxdepth 1 -type d -name 'plugin-wingmenu-*' | head -n1)"
  if [[ -z "$srcdir" ]]; then
    echo "WingMenu archive did not extract to plugin-wingmenu-*" >&2
    return 1
  fi

  # Fedora/LXQt 2.4's automoc can fail with:
  #   wingmenuplugin.h:88:1: error: Undefined interface
  # Make the interface declaration visible to moc without adding a duplicate
  # declaration for the real C++ compiler.
  if [[ -f "$srcdir/wingmenuplugin.h" ]] && ! grep -q 'Q_MOC_RUN.*ILXQtPanelPluginLibrary' "$srcdir/wingmenuplugin.h"; then
    sed -i '/class WingMenuLibrary/i\
#ifdef Q_MOC_RUN\
Q_DECLARE_INTERFACE(ILXQtPanelPluginLibrary, "lxqt.org/Panel/PluginInterface/3.0")\
#endif\
' "$srcdir/wingmenuplugin.h"
  fi

  cmake -B "${workdir}/build" -S "$srcdir" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_CXX_FLAGS="-I/usr/include/lxqt"
  cmake --build "${workdir}/build" --parallel "$(nproc)"
  cmake --install "${workdir}/build"
}

ensure_distributor_logo_icon() {
  mkdir -p /usr/share/icons/hicolor/scalable/apps

  local candidate
  for candidate in \
    /usr/share/icons/hicolor/scalable/apps/distributor-logo.svg \
    /usr/share/icons/hicolor/scalable/distributor-logo.svg \
    /usr/share/pixmaps/distributor-logo.svg \
    /usr/share/pixmaps/fedora-logo.svg \
    /usr/share/icons/hicolor/scalable/apps/start-here.svg
  do
    if [[ -f "$candidate" ]]; then
      cp -f "$candidate" /usr/share/icons/hicolor/scalable/apps/distributor-logo.svg
      return 0
    fi
  done

  echo "Warning: could not find distributor-logo.svg; WingMenu will still request icon=distributor-logo." >&2
}

install_remote_power_wrapper() {
  # remote-shutdown.py and remote-shutdown.service are managed elsewhere.
  # This wrapper is only the user-session action that WingMenu calls.
  cat > /usr/sbin/aurora-remote-power-action <<'EOF_REMOTE_POWER_ACTION'
#!/usr/bin/env bash
set -Eeuo pipefail

REMOTE_SHUTDOWN="/usr/sbin/remote-shutdown.py"
cmd="${1:-}"

case "$cmd" in
  shutdown|poweroff)
    action="org.freedesktop.login1.power-off"
    ;;
  reboot|restart)
    action="org.freedesktop.login1.reboot"
    ;;
  halt)
    action="org.freedesktop.login1.halt"
    ;;
  *)
    echo "usage: aurora-remote-power-action shutdown|reboot|halt" >&2
    exit 2
    ;;
esac

if [[ ! -x "$REMOTE_SHUTDOWN" ]]; then
  echo "$REMOTE_SHUTDOWN is missing or not executable" >&2
  exit 1
fi

user="${USER:-$(id -un)}"
session="${XDG_SESSION_ID:-}"

if [[ -z "$session" ]]; then
  session="$(loginctl list-sessions --no-legend 2>/dev/null | awk -v u="$user" '$3 == u {print $1; exit}')"
fi

exec "$REMOTE_SHUTDOWN" request "$user" "$session" "$action"
EOF_REMOTE_POWER_ACTION
  chmod 0755 /usr/sbin/aurora-remote-power-action
}

install_lxqt_runtime_deps
install_dark_breeze_lxqt_theme
install_wingmenu_build_deps
install_wingmenu_plugin
remove_wingmenu_build_deps
ensure_distributor_logo_icon
install_remote_power_wrapper

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
  /usr/share/icons/default \
  /usr/share/applications

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
plugins=wingmenu,quicklaunch,taskbar,statusnotifier,tray,volume,worldclock
position=Bottom
reserve-space=true
show-delay=0
type=panel
width=100
width-percent=true

[wingmenu]
alignment=Left
appLayout=1
categoryLeft=true
customizeLeave=true
hoverDelay=200
icon=distributor-logo
leaveActions=/usr/share/applications/aurora-lxqt-logout.desktop,/usr/share/applications/aurora-lxqt-reboot.desktop,/usr/share/applications/aurora-lxqt-shutdown.desktop
menuFile=/etc/xdg/menus/lxqt-applications.menu
searchBottom=true
showIcon=true
showText=false
sidebarLeft=true
switchOnHover=true
type=wingmenu

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

[worldclock]
alignment=Right
dateFormat=yyyy-MM-dd
showDate=false
showSeconds=false
timeFormat=HH:mm
type=worldclock
EOF_PANEL
cp /etc/skel/.config/lxqt/panel.conf /usr/etc/xdg/lxqt/panel.conf

cat > /usr/share/applications/aurora-lxqt-logout.desktop <<'EOF_LOGOUT_DESKTOP'
[Desktop Entry]
Type=Application
Name=Log Out
Comment=Log out of the current LXQt session
Icon=system-log-out
Exec=lxqt-leave --logout
Categories=System;
NoDisplay=true
EOF_LOGOUT_DESKTOP

cat > /usr/share/applications/aurora-lxqt-reboot.desktop <<'EOF_REBOOT_DESKTOP'
[Desktop Entry]
Type=Application
Name=Restart
Comment=Restart the computer
Icon=system-reboot
Exec=/usr/sbin/aurora-remote-power-action reboot
Categories=System;
NoDisplay=true
EOF_REBOOT_DESKTOP

cat > /usr/share/applications/aurora-lxqt-shutdown.desktop <<'EOF_SHUTDOWN_DESKTOP'
[Desktop Entry]
Type=Application
Name=Shut Down
Comment=Shut down the computer
Icon=system-shutdown
Exec=/usr/sbin/aurora-remote-power-action shutdown
Categories=System;
NoDisplay=true
EOF_SHUTDOWN_DESKTOP


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

seed_file() {
  [[ -f "\$2" || ! -f "\$1" ]] && return 0
  mkdir -p "\$(dirname "\$2")"
  cp "\$1" "\$2"
}

install_managed_file() {
  [[ ! -f "\$1" ]] && return 0
  mkdir -p "\$(dirname "\$2")"
  cp "\$1" "\$2"
}

# Force-refresh the configs this image owns when the version changes. This fixes
# homes that were seeded with KDE-Plasma/bright panel settings before this config.
stamp="\$HOME/.config/lxqt/.aurora-managed-config-version"
if [[ ! -f "\$stamp" ]] || [[ "\$(cat "\$stamp" 2>/dev/null)" != "${MANAGED_LXQT_CONFIG_VERSION}" ]]; then
  install_managed_file /etc/skel/.config/lxqt/lxqt.conf "\$HOME/.config/lxqt/lxqt.conf"
  install_managed_file /etc/skel/.config/lxqt/lxqt-config-appearance.conf "\$HOME/.config/lxqt/lxqt-config-appearance.conf"
  install_managed_file /etc/skel/.config/lxqt/panel.conf "\$HOME/.config/lxqt/panel.conf"
  install_managed_file /etc/skel/.config/gtk-3.0/settings.ini "\$HOME/.config/gtk-3.0/settings.ini"
  install_managed_file /etc/skel/.config/gtk-4.0/settings.ini "\$HOME/.config/gtk-4.0/settings.ini"
  install_managed_file /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml "\$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
  install_managed_file /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml "\$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
  install_managed_file /etc/skel/.icons/default/index.theme "\$HOME/.icons/default/index.theme"
  install_managed_file /etc/skel/.Xresources "\$HOME/.Xresources"
  mkdir -p "\$(dirname "\$stamp")"
  echo "${MANAGED_LXQT_CONFIG_VERSION}" > "\$stamp"
else
  seed_file /etc/skel/.config/lxqt/lxqt.conf "\$HOME/.config/lxqt/lxqt.conf"
  seed_file /etc/skel/.config/lxqt/lxqt-config-appearance.conf "\$HOME/.config/lxqt/lxqt-config-appearance.conf"
  seed_file /etc/skel/.config/lxqt/panel.conf "\$HOME/.config/lxqt/panel.conf"
  seed_file /etc/skel/.config/gtk-3.0/settings.ini "\$HOME/.config/gtk-3.0/settings.ini"
  seed_file /etc/skel/.config/gtk-4.0/settings.ini "\$HOME/.config/gtk-4.0/settings.ini"
  seed_file /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml "\$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
  seed_file /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml "\$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
  seed_file /etc/skel/.icons/default/index.theme "\$HOME/.icons/default/index.theme"
  seed_file /etc/skel/.Xresources "\$HOME/.Xresources"
fi

xrdb -merge "\$HOME/.Xresources" 2>/dev/null || true

dbus-update-activation-environment --systemd \
  DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP \
  QT_QPA_PLATFORM QT_QPA_PLATFORMTHEME XCURSOR_THEME XCURSOR_SIZE \
  2>/dev/null || true

xfconf-query -c xfwm4 -p /general/workspace_count -s 1 --create -t int 2>/dev/null || true
xfconf-query -c xfwm4 -p /general/tile_on_move -s true --create -t bool 2>/dev/null || true
xfconf-query -c xfwm4 -p /general/snap_to_border -s true --create -t bool 2>/dev/null || true
xfconf-query -c xfwm4 -p /general/snap_to_windows -s true --create -t bool 2>/dev/null || true
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
