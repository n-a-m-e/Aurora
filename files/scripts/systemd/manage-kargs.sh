#!/usr/bin/env bash
set -euo pipefail

CHANGED=0
CURRENT_KARGS="$(rpm-ostree kargs | tr ' ' '\n')"

LEGACY_IDS='6780|6784|6788|678A|6790|6798|679A|679E|6800|6810|6811|6820|6821|6825|6830|6831|6835|6837|6838|6839|683D|6840|6841|6849|6850|6858|6859|6818|6640|6641|6646|6647|6649|6650|6651|6658|665C|665D|6660|6663|6664|6665|6667|666F|67A0|67A1|67A2|67A8|67A9|67AA|67B0|67B1|67B8|67B9|67BA|67BE'

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
  else
    echo "Already present: $karg"
  fi
}

remove_karg() {
  local karg="$1"

  if grep -qxF "$karg" <<< "$CURRENT_KARGS"; then
    rpm-ostree kargs --delete-if-present="$karg"
    echo "Removed: $karg"
    CHANGED=1
    CURRENT_KARGS="$(rpm-ostree kargs | tr ' ' '\n')"
  else
    echo "Not present: $karg"
  fi
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
  local dev="${1#0x}"

  case "${dev^^}" in
    $LEGACY_IDS) echo "LEGACY" ;;
    *)           echo "MODERN" ;;
  esac
}

ensure_karg "selinux=0"

if gpu_info="$(get_amd_gpu)"; then
  read -r vendor device pci <<< "$gpu_info"
  gpu_class="$(classify_amd_gpu "$device")"

  echo "Detected AMD GPU:"
  echo "  vendor: $vendor"
  echo "  device: $device"
  echo "  pci:    $pci"
  echo "  class:  $gpu_class"

  for pattern in \
    '^radeon\.si_support=' \
    '^amdgpu\.si_support=' \
    '^radeon\.cik_support=' \
    '^amdgpu\.cik_support=' \
    '^amdgpu\.virtual_display='
  do
    while IFS= read -r karg; do
      [ -n "$karg" ] && remove_karg "$karg"
    done < <(grep "$pattern" <<< "$CURRENT_KARGS" || true)
  done

  case "$gpu_class" in
    LEGACY)
      echo "Using legacy/radeon path"
      for karg in "${LEGACY_KARGS[@]}"; do
        ensure_karg "$karg"
      done
      ;;

    MODERN)
      echo "Using modern/amdgpu-only path"
      ensure_karg "amdgpu.virtual_display=${pci},1"
      ;;
  esac
else
  echo "No AMD GPU detected; leaving existing GPU kargs unchanged."
fi

if [ "$CHANGED" -eq 1 ]; then
  echo "Kernel args changed. Rebooting..."
  systemctl reboot
else
  echo "No kernel arg changes made. No reboot needed."
fi
