#!/usr/bin/env bash
set -euo pipefail

CHANGED=0
CURRENT_KARGS="$(rpm-ostree kargs | tr ' ' '\n')"

LEGACY_IDS='6604|6605|6606|6607|6608|6610|6611|6613|6617|6620|6621|6623|6631|6640|6641|6646|6647|6649|6650|6651|6658|665C|665D|665F|6660|6663|6664|6665|6667|666F|6780|6784|6788|678A|6790|6791|6792|6798|6799|679A|679B|679E|679F|67A0|67A1|67A2|67A8|67A9|67AA|67B0|67B1|67B8|67B9|67BA|67BE|6800|6801|6802|6806|6808|6809|6810|6811|6816|6817|6818|6819|6820|6821|6822|6823|6824|6825|6826|6827|6828|6829|682A|682B|682C|682D|682F|6830|6831|6835|6837|6838|6839|683B|683D|683F'

LEGACY_KARGS=(
  "radeon.si_support=1"
  "amdgpu.si_support=0"
  "radeon.cik_support=1"
  "amdgpu.cik_support=0"
)

ensure_karg() {
  local karg="$1"
  if ! grep -qxF "$karg" <<< "$CURRENT_KARGS"; then
    rpm-ostree kargs --append="$karg"
    echo "Added: $karg"
    CHANGED=1
    CURRENT_KARGS="$(rpm-ostree kargs | tr ' ' '\n')"
  fi
}

remove_matching_kargs() {
  local pattern="$1"
  while IFS= read -r karg; do
    [ -n "$karg" ] || continue
    rpm-ostree kargs --delete-if-present="$karg"
    echo "Removed: $karg"
    CHANGED=1
    CURRENT_KARGS="$(rpm-ostree kargs | tr ' ' '\n')"
  done < <(grep "$pattern" <<< "$CURRENT_KARGS" || true)
}

get_amd_gpu() {
  local d vendor device pci

  for d in /sys/class/drm/card*/device; do
    vendor="$(cat "$d/vendor" 2>/dev/null || true)"
    device="$(cat "$d/device" 2>/dev/null || true)"
    [ "$vendor" = "0x1002" ] || continue
    pci="$(basename "$(readlink -f "$d")")"
    printf '%s %s %s\n' "$vendor" "$device" "$pci"
    return 0
  done

  return 1
}

classify_amd_gpu() {
  case "${1#0x}" in
    ${LEGACY_IDS}) echo "LEGACY" ;;
    *)             echo "MODERN" ;;
  esac
}

gpu_has_connected_display() {
  local target_pci="$1"
  local card status

  for card in /sys/class/drm/card[0-9]*; do
    [ -e "$card/device" ] || continue
    [ "$(basename "$(readlink -f "$card/device")")" = "$target_pci" ] || continue

    for status in "$card"-*/status; do
      [ -e "$status" ] || continue
      [ "$(cat "$status" 2>/dev/null || true)" = "connected" ] && return 0
    done
  done

  return 1
}

ensure_legacy_state() {
  local karg

  for karg in "${LEGACY_KARGS[@]}"; do
    ensure_karg "$karg"
  done

  remove_matching_kargs '^radeon\.si_support=0'
  remove_matching_kargs '^amdgpu\.si_support=1'
  remove_matching_kargs '^radeon\.cik_support=0'
  remove_matching_kargs '^amdgpu\.cik_support=1'
  remove_matching_kargs '^amdgpu\.virtual_display='
}

ensure_modern_state() {
  local pci="$1"
  local vd="amdgpu.virtual_display=${pci},1"

  remove_matching_kargs '^radeon\.si_support='
  remove_matching_kargs '^amdgpu\.si_support='
  remove_matching_kargs '^radeon\.cik_support='
  remove_matching_kargs '^amdgpu\.cik_support='

  if gpu_has_connected_display "$pci"; then
    remove_matching_kargs '^amdgpu\.virtual_display='
  elif ! grep -qxF "$vd" <<< "$CURRENT_KARGS"; then
    remove_matching_kargs '^amdgpu\.virtual_display='
    ensure_karg "$vd"
  fi
}

ensure_karg "selinux=0"

if gpu_info="$(get_amd_gpu)"; then
  read -r vendor device pci <<< "$gpu_info"
  gpu_class="$(classify_amd_gpu "$device")"

  echo "Detected AMD GPU: vendor=$vendor device=$device pci=$pci class=$gpu_class"

  case "$gpu_class" in
    LEGACY) ensure_legacy_state ;;
    MODERN) ensure_modern_state "$pci" ;;
  esac
else
  echo "No AMD GPU detected; leaving existing GPU kargs unchanged."
fi

ERROR_COUNT="$(journalctl -k -b --no-pager 2>/dev/null | grep -Eci 'PCIe Bus Error|AER:|BadTLP|BadDLLP|Timeout' || true)"
echo "PCIe/AER-like error count this boot: $ERROR_COUNT"

if [ "$ERROR_COUNT" -ge 20 ]; then
  ensure_karg "pcie_aspm=off"
fi

if [ "$CHANGED" -eq 1 ]; then
  echo "Kernel args changed. Rebooting..."
  systemctl reboot
else
  echo "No kernel arg changes made. No reboot needed."
fi
