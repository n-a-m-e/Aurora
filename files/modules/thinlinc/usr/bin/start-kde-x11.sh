#!/usr/bin/env bash
set +e

mkdir -p "$HOME/.cache"
exec >"$HOME/.cache/kde-x11-session.log" 2>&1

# X11 KDE Plasma desktop session using LXQt and XFWM4.

export DESKTOP_SESSION=plasma
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE
export KDE_SESSION_VERSION=6
export KDE_FULL_SESSION=true
export QT_QPA_PLATFORM=xcb

dbus-update-activation-environment --systemd \
  DISPLAY XAUTHORITY XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS \
  DESKTOP_SESSION XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP \
  KDE_SESSION_VERSION KDE_FULL_SESSION QT_QPA_PLATFORM \
  2>/dev/null || true

start_if_found() {
  local exe="$1"
  shift

  if command -v "$exe" >/dev/null 2>&1; then
    "$exe" "$@" &
    return 0
  fi

  if [[ -x "/usr/libexec/$exe" ]]; then
    "/usr/libexec/$exe" "$@" &
    return 0
  fi

  if [[ -x "/usr/lib64/libexec/$exe" ]]; then
    "/usr/lib64/libexec/$exe" "$@" &
    return 0
  fi

  echo "Warning: could not find $exe"
  return 1
}

start_if_found kglobalacceld6
start_if_found org_kde_powerdevil

xfwm4 --replace &

sleep 1

plasmashell &

wait
