#!/usr/bin/env bash
set -euo pipefail

ROOT="${AURORA_ROOT:-${GITHUB_WORKSPACE:-$(pwd)}}"
ROOT="$(cd "$ROOT" && pwd)"

TS_INTEGRATION="$ROOT/files/scripts/thinstation"
WORKDIR="${WORKDIR:-$ROOT/.build/thinstation}"
TS_REPO="https://github.com/Thinstation/thinstation-ng.git"
TS_REF="$(cat "$TS_INTEGRATION/THINSTATION_REF")"

TS_SRC="$WORKDIR/thinstation-ng"
RELEASE_DIR="$ROOT/release/thinstation"
PXE_DIR="$RELEASE_DIR/pxe"
REMOVE_LIST="$TS_INTEGRATION/config/packages-to-remove.list"

RPM_FILES=(core grub kernel firmware system ts other)

echo "Root:             $ROOT"
echo "Workdir:          $WORKDIR"
echo "ThinStation ref:  $TS_REF"
echo "Release dir:      $RELEASE_DIR"

rm -rf "$WORKDIR" "$RELEASE_DIR"
mkdir -p "$WORKDIR" "$PXE_DIR"

echo "Cloning ThinStation..."
git clone "$TS_REPO" "$TS_SRC"

cd "$TS_SRC"

echo "Checking out ThinStation ref..."
git fetch --all --tags --prune
git checkout "$TS_REF"
git reset --hard "$TS_REF"

echo "Pruning ThinStation package inputs..."

if [ -f "$REMOVE_LIST" ]; then
  echo "Using remove list: $REMOVE_LIST"
  echo

  while read -r pkg || [ -n "$pkg" ]; do
    # Trim whitespace.
    pkg="$(echo "$pkg" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"

    # Skip comments and blank lines.
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue

    found=false
    echo "Package: $pkg"

    # Remove from ts/rpms/* files.
    # Fixed-string matching keeps names with dots, hyphens, underscores, and plus signs literal.
    for name in "${RPM_FILES[@]}"; do
      file="$TS_SRC/ts/rpms/$name"
      [ -f "$file" ] || continue

      if grep -qxF "$pkg" < <(sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' "$file"); then
        sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' "$file" \
          | grep -vxF "$pkg" > "$file.tmp"

        mv "$file.tmp" "$file"

        echo "  removed from $name"
        found=true
      fi
    done

    # Remove from ts/build/packages/<pkg>.
    dir="$TS_SRC/ts/build/packages/$pkg"
    if [ -d "$dir" ]; then
      rm -rf "$dir"
      echo "  removed from packages"
      found=true
    fi

    if [ "$found" = false ]; then
      echo "  package not found anywhere"
    fi

    echo
  done < "$REMOVE_LIST"

  echo "Prune complete."
else
  echo "No packages-to-remove.list found; skipping prune."
fi

echo "Copying Aurora ThinStation config..."
cp "$TS_INTEGRATION/config/build.conf" \
   "$TS_SRC/ts/build/build.conf"

cp "$TS_INTEGRATION/config/thinstation.conf.buildtime" \
   "$TS_SRC/ts/build/thinstation.conf.buildtime"

if [ -f "$TS_INTEGRATION/config/thinstation.conf.network" ]; then
  cp "$TS_INTEGRATION/config/thinstation.conf.network" \
     "$TS_SRC/ts/build/thinstation.conf.network"
fi

echo "Preparing ThinStation chroot..."
sudo ./setup-chroot -i

echo "Building ThinStation PXE artifacts..."
sudo ./setup-chroot -b -o --license ACCEPT

echo "Collecting PXE artifacts..."

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

echo "Done. Artifacts:"
find "$RELEASE_DIR" -maxdepth 3 -type f -ls
