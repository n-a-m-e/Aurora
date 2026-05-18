#!/usr/bin/env bash
set -oue pipefail

export XDG_CURRENT_DESKTOP=ICEWM
export XDG_SESSION_DESKTOP=icewm
export DESKTOP_SESSION=icewm

# Keep display awake for kiosk/thinclient use.
xset -dpms || true
xset s off || true
xset s noblank || true

# Auto-enable connected displays. More specific multi-monitor layout can be
# added here later if needed.
xrandr --auto || true

exec icewm-session
