#!/usr/bin/env bash
set -euo pipefail

SCRIPT_VERSION="manage-kargs debug v2"

CHANGED=0
CURRENT_KARGS="$(rpm-ostree kargs | tr ' ' '\n')"

SDDM_CONF=/etc/sddm.conf.d/99-sunshine.conf
SDDM_AUTOLOGIN_USER="sunshine"
SDDM_AUTOLOGIN_SESSION="plasmax11.desktop"
SDDM_XSETUP=/etc/sddm/Xsetup

SUNSHINE_USER="sunshine"
SUNSHINE_HOME="$(getent passwd "$SUNSHINE_USER" | cut -d: -f6 || true)"
SUNSHINE_CONF="${SUNSHINE_HOME:+${SUNSHINE_HOME}/.config/sunshine/sunshine.conf}"

LEGACY_IDS='6604|6605|6606|6607|6608|6610|6611|6613|6617|6620|6621|6623|6631|6640|6641|6646|6647|6649|6650|6651|6658|665C|665D|665F|6660|6663|6664|6665|6667|666F|6780|6784|6788|678A|6790|6791|6792|6798|6799|679A|679B|679E|679F|67A0|67A1|67A2|67A8|67A9|67AA|67B0|67B1|67B8|67B9|67BA|67BE|6800|6801|6802|6806|6808|6809|6810|6811|6816|6817|6818|6819|6820|6821|6822|6823|6824|6825|6826|6827|6828|6829|682A|682B|682C|682D|682F|6830|6831|6835|6837|6838|6839|683B|683D|683F'

LEGACY_KARGS=(
  "radeon.si_support=1"
  "amdgpu.si_support=0"
  "radeon.cik_support=1"
  "amdgpu.cik_support=0"
)

LEGACY_WRONG_KARGS=(
  '^radeon\.si_support=0$'
  '^amdgpu\.si_support=1$'
  '^radeon\.cik_support=0$'
  '^amdgpu\.cik_support=1$'
)

MODERN_REMOVE_KARGS=(
  '^radeon\.si_support='
  '^amdgpu\.si_support='
  '^radeon\.cik_support='
  '^amdgpu\.cik_support='
)

log() {
  echo "[$(date '+%F %T')] $*"
}

dump_kargs() {
  log "Current kargs:"
  while IFS= read -r line; do
    [[ -n "$line" ]] && log "  $line"
  done <<< "$CURRENT_KARGS"
}

refresh_kargs() {
  CURRENT_KARGS="$(rpm-ostree kargs | tr ' ' '\n')"
}

mark_changed() {
  CHANGED=1
}

sync_kargs() {
  local mode="$1" pattern="${2:-}" value="${3:-}" array_name="${4:-}" karg
  local -a matches=() items=()

  if [[ -n "$array_name" ]]; then
    local -n arr="$array_name"
    items=("${arr[@]}")
  elif [[ "$mode" == "ensure" || "$mode" == "keep" ]]; then
    items=("$value")
  else
    items=("$pattern")
  fi

  if [[ "$mode" == "remove" || "$mode" == "keep" ]]; then
    for pattern in "${items[@]}"; do
      log "sync_kargs($mode): searching for pattern: $pattern"
      mapfile -t matches < <(grep -E "$pattern" <<< "$CURRENT_KARGS" || true)
      if (( ${#matches[@]} == 0 )); then
        log "sync_kargs($mode): no matches for pattern: $pattern"
      fi
      for karg in "${matches[@]}"; do
        [[ -z "$karg" ]] && continue
        if [[ "$mode" == "keep" && "$karg" == "$value" ]]; then
          log "sync_kargs(keep): keeping desired karg: $karg"
          continue
        fi
        log "sync_kargs($mode): deleting karg: $karg"
        rpm-ostree kargs --delete-if-present="$karg"
        mark_changed
        refresh_kargs
      done
    done
  fi

  if [[ "$mode" == "ensure" || "$mode" == "keep" ]]; then
    for value in "${items[@]}"; do
      if grep -qFxx "$value" <<< "$CURRENT_KARGS"; then
        log "sync_kargs($mode): already present: $value"
      else
        log "sync_kargs($mode): appending karg: $value"
        rpm-ostree kargs --append="$value"
        mark_changed
        refresh_kargs
      fi
    done
  fi
}

get_amd_gpu() {
  local dev vendor device class pci

  log "Scanning PCI for AMD display-class devices..."
  for dev in /sys/bus/pci/devices/*; do
    [[ -r "$dev/vendor" && -r "$dev/device" && -r "$dev/class" ]] || continue

    vendor="$(<"$dev/vendor" 2>/dev/null || true)"
    device="$(<"$dev/device" 2>/dev/null || true)"
    class="$(<"$dev/class" 2>/dev/null || true)"
    pci="$(basename "$dev")"

    log "PCI candidate: pci=$pci vendor=$vendor device=$device class=$class"

    [[ "$vendor" == "0x1002" ]] || continue
    [[ "$class" == "0x030000" || "$class" == "0x030200" ]] || continue

    log "Selected AMD GPU: pci=$pci vendor=$vendor device=$device class=$class"
    printf '%s %s %s\n' "$vendor" "$device" "$pci"
    return 0
  done

  log "No AMD display-class GPU found on PCI"
  return 1
}

classify_amd_gpu() {
  case "${1#0x}" in
    $LEGACY_IDS) echo "LEGACY" ;;
    *)           echo "MODERN" ;;
  esac
}

gpu_has_connected_display() {
  local target_pci="$1" card status
  local found_card=0

  log "Checking DRM connector state for PCI device $target_pci ..."
  for card in /sys/class/drm/card[0-9]*; do
    [[ -e "$card/device" ]] || continue
    [[ "$(basename "$(readlink -f "$card/device")")" == "$target_pci" ]] || continue
    found_card=1
    log "Found DRM card for $target_pci: $card"

    for status in "$card"-*/status; do
      [[ -e "$status" ]] || continue
      log "Connector status $(basename "$(dirname "$status")"): $(<"$status" 2>/dev/null || true)"
      [[ "$(<"$status" 2>/dev/null || true)" == "connected" ]] && return 0
    done
  done

  if (( found_card == 0 )); then
    log "No DRM card nodes found for $target_pci"
  else
    log "No connected DRM connectors found for $target_pci"
  fi

  return 1
}

ensure_sunshine_service_enabled() {
  log "Checking Sunshine prerequisites..."
  if ! id -u "$SUNSHINE_USER" >/dev/null 2>&1; then
    log "Sunshine user '$SUNSHINE_USER' does not exist; skipping service enable"
    return 0
  fi

  if ! loginctl show-user "$SUNSHINE_USER" -p Linger 2>/dev/null | grep -q '=yes$'; then
    log "Enabling linger for user $SUNSHINE_USER"
    loginctl enable-linger "$SUNSHINE_USER"
    mark_changed
  else
    log "Linger already enabled for $SUNSHINE_USER"
  fi

  if ! runuser -u "$SUNSHINE_USER" -- systemctl --user is-enabled sunshine >/dev/null 2>&1; then
    log "Enabling sunshine user service for $SUNSHINE_USER"
    runuser -u "$SUNSHINE_USER" -- systemctl --user enable sunshine
    mark_changed
  else
    log "Sunshine user service already enabled for $SUNSHINE_USER"
  fi
}

write_streaming_display_setup() {
  local sddm_conf_content xsetup_content

  sddm_conf_content="[Autologin]\nUser=${SDDM_AUTOLOGIN_USER}\nSession=${SDDM_AUTOLOGIN_SESSION}\nRelogin=false\n\n[X11]\nDisplayCommand=${SDDM_XSETUP}\n"
  mkdir -p /etc/sddm.conf.d
  if [[ ! -f "$SDDM_CONF" ]] || ! cmp -s <(printf '%b' "$sddm_conf_content") "$SDDM_CONF"; then
    log "Writing $SDDM_CONF"
    printf '%b' "$sddm_conf_content" > "$SDDM_CONF"
    mark_changed
  else
    log "$SDDM_CONF already up to date"
  fi

  xsetup_content='#!/usr/bin/env bash\nset -eu\n\nSUNSHINE_CONF="'"$SUNSHINE_CONF"'"\n[ -n "$SUNSHINE_CONF" ] || exit 0\n\nMONITOR_LINE="$(xrandr --listmonitors 2>/dev/null | awk '\''NR==2 {print; exit}'\'')"\n[ -n "${MONITOR_LINE:-}" ] || exit 0\n\nMONITOR_ID="$(awk '\''{gsub(/:/, "", $1); print $1}'\'' <<< "$MONITOR_LINE")"\nOUT="$(awk '\''{print $NF}'\'' <<< "$MONITOR_LINE")"\n[ -n "${MONITOR_ID:-}" ] || exit 0\n[ -n "${OUT:-}" ] || exit 0\n\nxrandr --newmode "3840x1080_60.00" 334.75 3840 3888 3920 4000 1080 1083 1093 1111 +hsync -vsync 2>/dev/null || true\nxrandr --addmode "$OUT" "3840x1080_60.00" 2>/dev/null || true\nxrandr --output "$OUT" --mode "3840x1080_60.00" --fb 3840x1080\n\nmkdir -p "$(dirname "$SUNSHINE_CONF")"\ntouch "$SUNSHINE_CONF"\nif grep -qE "^[[:space:]]*output_name[[:space:]]*=" "$SUNSHINE_CONF"; then\n  sed -i -E "s|^[[:space:]]*output_name[[:space:]]*=.*$|output_name = ${MONITOR_ID}|" "$SUNSHINE_CONF"\nelse\n  printf "\\noutput_name = %s\\n" "$MONITOR_ID" >> "$SUNSHINE_CONF"\nfi\n'
  mkdir -p "$(dirname "$SDDM_XSETUP")"
  if [[ ! -f "$SDDM_XSETUP" ]] || ! cmp -s <(printf '%b' "$xsetup_content") "$SDDM_XSETUP"; then
    log "Writing $SDDM_XSETUP"
    printf '%b' "$xsetup_content" > "$SDDM_XSETUP"
    chmod 0755 "$SDDM_XSETUP"
    mark_changed
  else
    log "$SDDM_XSETUP already up to date"
  fi
}

remove_streaming_display_setup() {
  local path
  for path in "$SDDM_CONF" "$SDDM_XSETUP"; do
    if [[ -e "$path" ]]; then
      log "Removing $path"
      rm -f "$path"
      mark_changed
    else
      log "$path already absent"
    fi
  done
}

ensure_legacy_kargs() {
  log "Applying LEGACY GPU policy"
  sync_kargs ensure '' '' LEGACY_KARGS
  sync_kargs remove '' '' LEGACY_WRONG_KARGS
  sync_kargs remove '^amdgpu\.virtual_display='
  remove_streaming_display_setup
}

ensure_modern_kargs() {
  local pci="$1" vd="amdgpu.virtual_display=${pci},1"
  local sunshine_ready=0

  log "Applying MODERN GPU policy for $pci"
  sync_kargs remove '' '' MODERN_REMOVE_KARGS

  if command -v sunshine >/dev/null 2>&1; then
    log "Found sunshine binary"
  else
    log "Sunshine binary not found"
  fi

  if id -u "$SUNSHINE_USER" >/dev/null 2>&1; then
    log "Found sunshine user: $SUNSHINE_USER"
  else
    log "Sunshine user missing: $SUNSHINE_USER"
  fi

  if [[ -n "$SUNSHINE_CONF" ]]; then
    log "Sunshine config path resolved: $SUNSHINE_CONF"
  else
    log "Sunshine config path could not be resolved"
  fi

  if command -v sunshine >/dev/null 2>&1 \
    && id -u "$SUNSHINE_USER" >/dev/null 2>&1 \
    && [[ -n "$SUNSHINE_CONF" ]] \
    && ! gpu_has_connected_display "$pci"; then
    sunshine_ready=1
    log "Modern GPU has no connected display and Sunshine prerequisites are met"
  else
    log "Modern GPU will not use virtual display path"
  fi

  if (( sunshine_ready )); then
    ensure_sunshine_service_enabled
    sync_kargs keep '^amdgpu\.virtual_display=' "$vd"
    write_streaming_display_setup
  else
    sync_kargs remove '^amdgpu\.virtual_display='
    remove_streaming_display_setup
  fi
}

main() {
  local gpu_info vendor device pci gpu_class error_count

  log "===== $SCRIPT_VERSION starting ====="
  log "Boot ID: $(cat /proc/sys/kernel/random/boot_id 2>/dev/null || echo unknown)"
  dump_kargs

  sync_kargs ensure "" "selinux=0"

  if gpu_info="$(get_amd_gpu)"; then
    read -r vendor device pci <<< "$gpu_info"
    gpu_class="$(classify_amd_gpu "$device")"
    log "Detected AMD GPU: vendor=$vendor device=$device pci=$pci class=$gpu_class"

    case "$gpu_class" in
      LEGACY) ensure_legacy_kargs ;;
      MODERN) ensure_modern_kargs "$pci" ;;
    esac
  else
    log "No AMD GPU found on PCI"
    sync_kargs remove '^amdgpu\.virtual_display='
    remove_streaming_display_setup
  fi

  error_count="$(journalctl -k -b --no-pager 2>/dev/null | grep -Eci 'PCIe Bus Error|AER:|BadTLP|BadDLLP|Timeout' || true)"
  log "PCIe/AER-like error count this boot: $error_count"
  if (( error_count >= 20 )); then
    log "AER threshold reached (>=20); ensuring pcie_aspm=off"
    sync_kargs ensure "" "pcie_aspm=off"
  else
    log "AER threshold not reached; leaving pcie_aspm as-is"
  fi

  log "Final kargs after evaluation:"
  dump_kargs

  if (( CHANGED )); then
    log "REBOOT DECISION: yes"
    log "Reason: kernel args, Sunshine service state, or streaming display files changed"
    log "Requesting reboot now"
    #systemctl reboot
  else
    log "REBOOT DECISION: no"
    log "Reason: no changes were required"
  fi
}

main "$@"
