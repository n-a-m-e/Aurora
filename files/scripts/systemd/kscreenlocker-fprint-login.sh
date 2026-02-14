#!/usr/bin/env bash
set -euo pipefail

dbus-monitor --system \
  "type='signal',interface='org.freedesktop.login1.Manager',member='SessionNew'" \
  "type='method_call',interface='net.reactivated.Fprint.Device',member='VerifyStop'" \
  2>/dev/null | while IFS= read -r l; do

  [[ "$l" == *"member=SessionNew"* || "$l" == *"member=VerifyStop"* ]] || continue

  if [[ "$l" == *"member=SessionNew"* ]]; then
    sid=""
    while IFS= read -r l2; do
      [[ -z "$l2" ]] && break
      [[ "$l2" =~ string\ \"([0-9]+)\" ]] || continue
      seat="$(loginctl show-session "${BASH_REMATCH[1]}" -p Seat --value 2>/dev/null || true)"
      [[ "$seat" == seat0 ]] || continue
      sid="${BASH_REMATCH[1]}"
      break
    done
  else
    sid="$(loginctl list-sessions --no-legend 2>/dev/null | awk '$4=="seat0" && $6=="user"{print $1; exit}' || true)"
  fi

  [[ -n "${sid:-}" ]] || continue
  user="$(loginctl show-session "$sid" -p Name --value 2>/dev/null || true)"
  [[ -n "${user:-}" ]] || continue

  if [[ "$l" == *"member=SessionNew"* ]]; then
    mkdir -p /etc/sddm.conf.d
    printf "%s\n" "[Autologin]" "User=$user" "Session=plasma" > /etc/sddm.conf.d/autologin.conf
    loginctl lock-session "$sid" 2>/dev/null || true
    continue
  fi

  [[ "$(loginctl show-session "$sid" -p LockedHint --value 2>/dev/null || true)" == yes ]] || continue
  pgrep -u "$user" -x kscreenlocker_greet >/dev/null 2>&1 || continue
  pkill -u "$user" -x kscreenlocker_greet >/dev/null 2>&1 || true
done
