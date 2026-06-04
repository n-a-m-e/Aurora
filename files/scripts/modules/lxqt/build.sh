#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

# This build script intentionally styles ONLY:
#   1. the LXQt bottom panel
#   2. the WingMenu popup/button
#
# It does NOT set global KDE, Qt, GTK, icon, cursor, wallpaper, XFCE,
# GNOME, qt5ct, qt6ct, or Breeze styling.

LXQT_PANEL_THEME="Aurora-Panel-WingMenu"
MANAGED_LXQT_CONFIG_VERSION="2026-06-04-panel-wingmenu-only-2"
REMOTE_SHUTDOWN="/usr/bin/remote-shutdown.py"
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

install_lxqt_runtime_deps() {
  rpm-ostree install --idempotent lxqt-session
}

install_wingmenu_build_deps() {
  echo "Installing temporary WingMenu build dependencies..."
  rpm-ostree install --idempotent "${WINGMENU_BUILD_DEPS[@]}"
}

remove_wingmenu_build_deps() {
  # Keep this as a no-op for rpm-ostree determinism. Removing build deps inside
  # the same layer can fail depsolving if shared RPM macro/data packages remain
  # required by installed artifacts.
  true
}

allow_kde_polkit_agent_in_lxqt() {
  # Not styling. This only permits the KDE polkit auth agent to start in LXQt.
  for file in \
    /usr/share/applications/org.kde.polkit-kde-authentication-agent-1.desktop \
    /usr/etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop \
    /etc/xdg/autostart/org.kde.polkit-kde-authentication-agent-1.desktop
  do
    [[ -f "$file" ]] && sed -i 's/^OnlyShowIn=.*/OnlyShowIn=KDE;LXQt;XFCE;/' "$file"
  done
}

install_panel_wingmenu_lxqt_theme() {
  # Minimal LXQt theme. Keep selectors scoped to lxqt-panel and WingMenu so this
  # theme does not deliberately style unrelated LXQt/Qt applications.
  local theme_dir="/usr/share/lxqt/themes/${LXQT_PANEL_THEME}"
  mkdir -p "$theme_dir"

  cat > "${theme_dir}/lxqt-panel.qss" <<'EOF_QSS'
/* Aurora panel/WingMenu-only LXQt theme.
   Deliberately avoid broad QWidget, QMenu, QPushButton, QLabel, etc. rules. */

/* Bottom panel container and common panel plugin surfaces. */
#LXQtPanel,
LXQtPanel,
PanelWidget,
#PanelWidget {
    background: #2a2e32;
    color: #fcfcfc;
}

/* Panel buttons and plugin buttons. Kept panel-scoped where LXQt exposes names. */
#LXQtPanel QToolButton,
LXQtPanel QToolButton,
PanelWidget QToolButton,
#PanelWidget QToolButton {
    color: #fcfcfc;
    background: transparent;
    border: 1px solid transparent;
    border-radius: 2px;
    padding: 2px 6px;
}

#LXQtPanel QToolButton:hover,
LXQtPanel QToolButton:hover,
PanelWidget QToolButton:hover,
#PanelWidget QToolButton:hover,
#LXQtPanel QToolButton:checked,
LXQtPanel QToolButton:checked,
PanelWidget QToolButton:checked,
#PanelWidget QToolButton:checked {
    color: #fcfcfc;
    background: rgba(61, 174, 233, 33%);
    border: 1px solid rgba(61, 174, 233, 100%);
}

/* Taskbar items inside the bottom panel. */
#LXQtPanel TaskButton,
LXQtPanel TaskButton,
PanelWidget TaskButton,
#PanelWidget TaskButton {
    color: #fcfcfc;
    background: transparent;
    border: 1px solid transparent;
    border-radius: 2px;
    padding: 2px 8px;
}

#LXQtPanel TaskButton:hover,
LXQtPanel TaskButton:hover,
PanelWidget TaskButton:hover,
#PanelWidget TaskButton:hover,
#LXQtPanel TaskButton:checked,
LXQtPanel TaskButton:checked,
PanelWidget TaskButton:checked,
#PanelWidget TaskButton:checked {
    color: #fcfcfc;
    background: rgba(61, 174, 233, 33%);
    border: 1px solid rgba(61, 174, 233, 100%);
}

/* WingMenu popup. The build step below patches the plugin to set objectName=WingMenu. */
#WingMenu,
#WingMenu QWidget,
#WingMenu QFrame,
#WingMenu QStackedWidget {
    background: #2a2e32;
    color: #fcfcfc;
}

#WingMenu QLineEdit,
#WingMenu #MainMenuSearchEdit {
    background: #1b1e20;
    color: #fcfcfc;
    border: 1px solid #5e6061;
    border-radius: 2px;
    padding: 4px 6px;
    selection-color: #fcfcfc;
    selection-background-color: #3daee9;
}

#WingMenu QListView,
#WingMenu ApplicationsView {
    background: #303439;
    color: #fcfcfc;
    border: 1px solid #484c4f;
    outline: 0;
}

#WingMenu QListView::item {
    color: #fcfcfc;
    background: transparent;
    border: 1px solid transparent;
    border-radius: 2px;
    padding: 5px 8px;
}

#WingMenu QListView::item:hover,
#WingMenu QListView::item:selected {
    color: #fcfcfc;
    background: rgba(61, 174, 233, 33%);
    border: 1px solid rgba(61, 174, 233, 100%);
}

#WingMenu QToolButton#CategoryButton {
    color: #fcfcfc;
    background: transparent;
    border: 1px solid transparent;
    border-radius: 2px;
    padding: 6px 10px;
    text-align: left;
}

#WingMenu QToolButton#CategoryButton:hover,
#WingMenu QToolButton#CategoryButton:checked,
#WingMenu QToolButton#CategoryButton:pressed {
    color: #fcfcfc;
    background: rgba(61, 174, 233, 33%);
    border: 1px solid rgba(61, 174, 233, 100%);
    text-align: left;
}

#WingMenu QToolButton {
    color: #fcfcfc;
    background: transparent;
    border: 1px solid transparent;
    border-radius: 2px;
}

#WingMenu QLabel {
    color: #fcfcfc;
    background: transparent;
}
EOF_QSS
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

  # Fedora/LXQt 2.4 automoc compatibility.
  if [[ -f "$srcdir/wingmenuplugin.h" ]] && ! grep -q 'Q_MOC_RUN.*ILXQtPanelPluginLibrary' "$srcdir/wingmenuplugin.h"; then
    sed -i '/class WingMenuLibrary/i\
#ifdef Q_MOC_RUN\
Q_DECLARE_INTERFACE(ILXQtPanelPluginLibrary, "lxqt.org/Panel/PluginInterface/3.0")\
#endif\
' "$srcdir/wingmenuplugin.h"
  fi

  # Give the popup widget a stable object name so only WingMenu can be styled.
  if [[ -f "$srcdir/wingmenuwidget.cpp" ]] && ! grep -q 'setObjectName(QSL("WingMenu"))' "$srcdir/wingmenuwidget.cpp"; then
    sed -i '0,/^{$/{s/^{$/{\n    setObjectName(QSL("WingMenu"));/}' "$srcdir/wingmenuwidget.cpp"
  fi

  # Keep the category column text left aligned inside WingMenu only.
  if [[ -f "$srcdir/wingmenuwidget.cpp" ]] && ! grep -q 'text-align: left' "$srcdir/wingmenuwidget.cpp"; then
    sed -i 's/tb->setToolButtonStyle(Qt::ToolButtonTextBesideIcon);/tb->setToolButtonStyle(Qt::ToolButtonTextBesideIcon);\n    tb->setStyleSheet(QSL("text-align: left;"));/' "$srcdir/wingmenuwidget.cpp"
  fi

  cmake -B "${workdir}/build" -S "$srcdir" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_CXX_FLAGS="-I/usr/include/lxqt"

  cmake --build "${workdir}/build" --parallel "$(nproc)"
  cmake --install "${workdir}/build"
}

install_remote_power_wrapper() {
  [[ -f "$REMOTE_SHUTDOWN" ]] && chmod a+x "$REMOTE_SHUTDOWN"

  # remote-shutdown.py and remote-shutdown.service are managed elsewhere.
  # This wrapper is only the user-session action that WingMenu calls.
  cat > /usr/bin/aurora-remote-power-action <<'EOF_REMOTE_POWER_ACTION'
#!/usr/bin/env bash
set -Eeuo pipefail

REMOTE_SHUTDOWN="/usr/bin/remote-shutdown.py"
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

  chmod 0755 /usr/bin/aurora-remote-power-action
}

install_lxqt_defaults() {
  mkdir -p \
    /usr/bin \
    /usr/share/xsessions \
    /etc/sddm.conf.d \
    /etc/skel/.config/lxqt \
    /usr/etc/xdg/lxqt \
    /usr/share/applications

  # Minimal LXQt config: set only the LXQt theme used by lxqt-panel.qss.
  # Do not set icon_theme, Qt style, font, cursor, GTK, KDE, or other app styling.
  cat > /etc/skel/.config/lxqt/lxqt.conf <<EOF_LXQT
[General]
theme=${LXQT_PANEL_THEME}
single_click_activate=false
EOF_LXQT

  cp /etc/skel/.config/lxqt/lxqt.conf /usr/etc/xdg/lxqt/lxqt.conf

  # Panel layout/config. This controls the bottom panel and WingMenu only.
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
}

install_wingmenu_leave_actions() {
  cat > /usr/share/applications/aurora-lxqt-logout.desktop <<'EOF_LOGOUT_DESKTOP'
[Desktop Entry]
Type=Application
Name=Log Out
Comment=Log out of the current LXQt session
Icon=/usr/share/icons/Adwaita/symbolic/actions/system-log-out-rtl-symbolic.svg
Exec=lxqt-leave --logout
Categories=System;
NoDisplay=true
EOF_LOGOUT_DESKTOP

  cat > /usr/share/applications/aurora-lxqt-reboot.desktop <<'EOF_REBOOT_DESKTOP'
[Desktop Entry]
Type=Application
Name=Restart
Comment=Restart the computer
Icon=/usr/share/icons/Adwaita/symbolic/actions/view-refresh-symbolic.svg
Exec=/usr/bin/aurora-remote-power-action reboot
Categories=System;
NoDisplay=true
EOF_REBOOT_DESKTOP

  cat > /usr/share/applications/aurora-lxqt-shutdown.desktop <<'EOF_SHUTDOWN_DESKTOP'
[Desktop Entry]
Type=Application
Name=Shut Down
Comment=Shut down the computer
Icon=/usr/share/icons/Adwaita/symbolic/actions/system-shutdown-symbolic.svg
Exec=/usr/bin/aurora-remote-power-action shutdown
Categories=System;
NoDisplay=true
EOF_SHUTDOWN_DESKTOP
}

install_lxqt_start_script() {
  cat > /usr/bin/start-lxqt.sh <<EOF_START
#!/usr/bin/env bash
set +e

mkdir -p "\$HOME/.cache"
exec >"\$HOME/.cache/lxqt-session.log" 2>&1

export DESKTOP_SESSION=plasma
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE
export KDE_SESSION_VERSION=6
export KDE_FULL_SESSION=true
export QT_QPA_PLATFORM=xcb
export QT_QPA_PLATFORMTHEME=kde

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

# Force-refresh only the LXQt files this image owns: lxqt.conf and panel.conf.
# No GTK/KDE/Qt/icon/cursor/font/wallpaper config is seeded or modified.
stamp="\$HOME/.config/lxqt/.aurora-managed-panel-wingmenu-version"
if [[ ! -f "\$stamp" ]] || [[ "\$(cat "\$stamp" 2>/dev/null)" != "${MANAGED_LXQT_CONFIG_VERSION}" ]]; then
  install_managed_file /etc/skel/.config/lxqt/lxqt.conf "\$HOME/.config/lxqt/lxqt.conf"
  install_managed_file /etc/skel/.config/lxqt/panel.conf "\$HOME/.config/lxqt/panel.conf"
  mkdir -p "\$(dirname "\$stamp")"
  echo "${MANAGED_LXQT_CONFIG_VERSION}" > "\$stamp"
else
  seed_file /etc/skel/.config/lxqt/lxqt.conf "\$HOME/.config/lxqt/lxqt.conf"
  seed_file /etc/skel/.config/lxqt/panel.conf "\$HOME/.config/lxqt/panel.conf"
fi

# Export only session variables needed by DBus/systemd activation, not styling vars.
dbus-update-activation-environment --systemd \
  DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP \
  QT_QPA_PLATFORM BROWSER TERMINAL TERM \
  2>/dev/null || true

lxqt-globalkeysd &
lxqt-notificationd &
lxqt-powermanagement &
lxqt-panel &
nm-applet &

exec xfwm4 --replace
EOF_START

  chmod a+x /usr/bin/start-lxqt.sh
}

main() {
  install_lxqt_runtime_deps
  allow_kde_polkit_agent_in_lxqt
  install_panel_wingmenu_lxqt_theme
  install_wingmenu_build_deps
  install_wingmenu_plugin
  remove_wingmenu_build_deps
  install_remote_power_wrapper
  install_lxqt_defaults
  install_wingmenu_leave_actions
  install_lxqt_start_script
  install_sddm_x11_config
}

main "$@"
