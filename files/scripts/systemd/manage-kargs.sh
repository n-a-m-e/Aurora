#!/usr/bin/env bash
set -euo pipefail

PCI="$(
  for d in /sys/class/drm/card*/device; do
    [ "$(cat "$d/vendor" 2>/dev/null)" = "0x1002" ] || continue
    [ "$(basename "$(readlink -f "$d/driver" 2>/dev/null)")" = "amdgpu" ] || continue
    basename "$(readlink -f "$d")"
    break
  done
)"

CHANGED=0
CURRENT_KARGS="$(rpm-ostree kargs | tr ' ' '\n')"

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

AMD_KARGS=(
  "radeon.si_support=1"
  "amdgpu.si_support=0"
  "radeon.cik_support=1"
  "amdgpu.cik_support=0"
)

ensure_karg "selinux=0"

if [ -n "$PCI" ]; then
  echo "Detected AMD GPU on $PCI"

  for karg in "${AMD_KARGS[@]}"; do
    ensure_karg "$karg"
  done

  ensure_karg "amdgpu.virtual_display=${PCI},1"
else
  echo "No AMD GPU using amdgpu driver found"

  for karg in "${AMD_KARGS[@]}"; do
    remove_karg "$karg"
  done

  while IFS= read -r karg; do
    [ -n "$karg" ] && remove_karg "$karg"
  done < <(grep '^amdgpu\.virtual_display=' <<< "$CURRENT_KARGS" || true)
fi

if [ "$CHANGED" -eq 1 ]; then
  echo "Kernel args changed. Rebooting..."
  systemctl reboot
else
  echo "No kernel arg changes made. No reboot needed."
fi
