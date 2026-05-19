#!/usr/bin/env bash
set -euo pipefail

TS_SRC="${1:?Usage: collect-artifacts.sh <thinstation-src> <release-dir>}"
RELEASE_DIR="${2:?Usage: collect-artifacts.sh <thinstation-src> <release-dir>}"

ROOT="${AURORA_ROOT:-${GITHUB_WORKSPACE:-$(pwd)}}"
ROOT="$(cd "$ROOT" && pwd)"

TS_INTEGRATION="$ROOT/files/scripts/thinstation"

PXE_DIR="$RELEASE_DIR/pxe"
mkdir -p "$PXE_DIR"

BOOT_DIR="$TS_SRC/ts/build/boot-images/initrd"

if [ ! -d "$BOOT_DIR" ]; then
  echo "Expected ThinStation boot output directory not found:"
  echo "$BOOT_DIR"
  echo
  echo "Searching for boot artifacts..."
  find "$TS_SRC/ts/build/boot-images" -maxdepth 4 -type f -ls || true
  exit 1
fi

echo "Using boot artifact directory:"
echo "$BOOT_DIR"

VMLINUX="$(
  find "$BOOT_DIR" -type f \
    \( -name 'vmlinuz' -o -name 'vmlinuz-*' \) \
    | head -n1
)"

INITRD="$(
  find "$BOOT_DIR" -type f \
    \( -name 'initrd' -o -name 'initrd.img' -o -name 'initrd-*' \) \
    | head -n1
)"

if [ -z "$VMLINUX" ] || [ -z "$INITRD" ]; then
  echo "Could not find vmlinuz/initrd in $BOOT_DIR"
  find "$BOOT_DIR" -type f -ls
  exit 1
fi

cp "$VMLINUX" "$PXE_DIR/vmlinuz"
cp "$INITRD" "$PXE_DIR/initrd"

if [ -f "$TS_INTEGRATION/config/thinstation.conf.network" ]; then
  cp "$TS_INTEGRATION/config/thinstation.conf.network" \
     "$PXE_DIR/thinstation.conf.network"
fi

cp "$TS_INTEGRATION/config/aurora-thinstation.ipxe" \
   "$PXE_DIR/aurora-thinstation.ipxe"

(
  cd "$PXE_DIR"
  sha256sum * > "$RELEASE_DIR/aurora-thinstation-pxe.sha256"
)

echo "PXE artifacts collected in:"
echo "$PXE_DIR"
