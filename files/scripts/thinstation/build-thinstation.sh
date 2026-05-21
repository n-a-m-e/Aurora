#!/usr/bin/env bash
set -euo pipefail

ROOT="${AURORA_ROOT:-${GITHUB_WORKSPACE:-$(pwd)}}"
ROOT="$(cd "$ROOT" && pwd)"

TS_INTEGRATION="$ROOT/files/scripts/thinstation"
WORKDIR="${WORKDIR:-$ROOT/.build/thinstation}"
TS_SRC="$WORKDIR/thinstation-ng"
TS_REPO="https://github.com/Thinstation/thinstation-ng.git"
TS_REF="$(cat "$TS_INTEGRATION/THINSTATION_REF")"

RELEASE_DIR="$ROOT/release/thinstation"
PXE_DIR="$RELEASE_DIR/pxe"

PRUNE_RPM_FILES=(firmware system other)

REQUIRED_RPMS=(
  xorriso
  squashfs-tools
  glib2-devel
  librsvg2-tools
  ImageMagick
  tigervnc-server-minimal
  samba-common-tools
  which
  util-linux-core
  gawk
  tar
)

REQUIRED_PACKAGES=(
  coreutils
  file
  tar
  glib2
  util-linux
)

PROTECTED_PACKAGES=()

clean() {
  sed -E 's/#.*$//; s/^[[:space:]]+//; s/[[:space:]]+$//'
}

is_required_rpm() {
  local rpm="$1" item
  for item in "${REQUIRED_RPMS[@]}"; do
    [ "$rpm" = "$item" ] && return 0
  done
  return 1
}

is_protected_package() {
  local pkg="$1" item
  for item in "${PROTECTED_PACKAGES[@]}"; do
    [ "$pkg" = "$item" ] && return 0
  done
  return 1
}

protect_package() {
  local pkg="$1"
  [ -z "$pkg" ] && return 0

  if ! is_protected_package "$pkg"; then
    PROTECTED_PACKAGES+=("$pkg")
    echo "  protected package: $pkg"
  fi
}

protect_package_tree() {
  local pkg="$1" dep dep_file
  [ -z "$pkg" ] && return 0
  is_protected_package "$pkg" && return 0

  protect_package "$pkg"

  dep_file="$TS_SRC/ts/build/packages/$pkg/dependencies"
  [ -f "$dep_file" ] || return 0

  while read -r dep || [ -n "$dep" ]; do
    dep="$(printf '%s\n' "$dep" | clean)"
    [ -z "$dep" ] && continue
    protect_package_tree "$dep"
  done < "$dep_file"
}

append_required_rpms_to_system() {
  local system_file="$TS_SRC/ts/rpms/system"
  local rpm

  echo
  echo "Appending REQUIRED_RPMS to ts/rpms/system..."

  touch "$system_file"

  for rpm in "${REQUIRED_RPMS[@]}"; do
    if grep -qxF "$rpm" "$system_file"; then
      echo "  already in system: $rpm"
    else
      echo "$rpm" >> "$system_file"
      echo "  added to system: $rpm"
    fi
  done
}

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

echo "Protecting REQUIRED_PACKAGES..."
for pkg in "${REQUIRED_PACKAGES[@]}"; do
  protect_package "$pkg"
done

echo "Protecting packages from build.conf and dependencies..."
while read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue
  protect_package_tree "$pkg"
done < <(
  sed 's/#.*$//' "$TS_INTEGRATION/config/build.conf" \
    | awk '$1 == "package" || $1 == "pkg" { print $2 }'
)

echo
echo "Final protected ThinStation package list:"
printf '  %s\n' "${PROTECTED_PACKAGES[@]}" | sort -u

append_required_rpms_to_system

echo
echo "Pruning RPM lists to REQUIRED_RPMS only: ${PRUNE_RPM_FILES[*]}"
for name in "${PRUNE_RPM_FILES[@]}"; do
  file="$TS_SRC/ts/rpms/$name"
  [ -f "$file" ] || continue

  tmp="$(mktemp)"
  kept=0
  removed=0

  while read -r line || [ -n "$line" ]; do
    line="$(printf '%s\n' "$line" | clean)"

    if [ -z "$line" ]; then
      echo "$line" >> "$tmp"
    elif is_required_rpm "$line"; then
      echo "$line" >> "$tmp"
      kept=$((kept + 1))
    else
      echo "  removed from $name: $line"
      removed=$((removed + 1))
    fi
  done < "$file"

  mv "$tmp" "$file"
  echo "  $name: kept $kept, removed $removed"
done

echo
echo "Pruning package directories..."
package_root="$TS_SRC/ts/build/packages"
kept=0
removed=0

while read -r dir; do
  pkg="$(basename "$dir")"

  if is_protected_package "$pkg"; then
    kept=$((kept + 1))
  else
    rm -rf "$dir"
    echo "  removed from packages: $pkg"
    removed=$((removed + 1))
  fi
done < <(find "$package_root" -mindepth 1 -maxdepth 1 -type d | sort)

echo "  packages: kept $kept, removed $removed"

echo "Copying Aurora ThinStation config..."
cp "$TS_INTEGRATION/config/build.conf" "$TS_SRC/ts/build/build.conf"
cp "$TS_INTEGRATION/config/thinstation.conf.buildtime" "$TS_SRC/ts/build/thinstation.conf.buildtime"

if [ -f "$TS_INTEGRATION/config/thinstation.conf.network" ]; then
  cp "$TS_INTEGRATION/config/thinstation.conf.network" "$TS_SRC/ts/build/thinstation.conf.network"
fi

echo "Validating selected build.conf packages..."
missing=()

while read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue
  [ -d "$TS_SRC/ts/build/packages/$pkg" ] || missing+=("$pkg")
done < <(
  sed 's/#.*$//' "$TS_SRC/ts/build/build.conf" \
    | awk '$1 == "package" || $1 == "pkg" { print $2 }'
)

if [ "${#missing[@]}" -gt 0 ]; then
  echo "Missing selected packages after pruning:"
  printf '  %s\n' "${missing[@]}"
  exit 1
fi

echo "Preparing ThinStation chroot..."
sudo ./setup-chroot -i

echo "Building ThinStation PXE artifacts..."
sudo ./setup-chroot -a -b -o --license ACCEPT

echo "Collecting PXE artifacts..."
BOOT_DIR="$TS_SRC/ts/build/boot-images/initrd"

if [ ! -d "$BOOT_DIR" ]; then
  echo "Expected boot output directory not found: $BOOT_DIR"
  find "$TS_SRC/ts/build/boot-images" -maxdepth 4 -type f -ls || true
  exit 1
fi

VMLINUX="$(find "$BOOT_DIR" -type f \( -name 'vmlinuz' -o -name 'vmlinuz-*' \) | head -n1)"
INITRD="$(find "$BOOT_DIR" -type f \( -name 'initrd' -o -name 'initrd.img' -o -name 'initrd-*' \) | head -n1)"

if [ -z "$VMLINUX" ] || [ -z "$INITRD" ]; then
  echo "Could not find vmlinuz/initrd in $BOOT_DIR"
  find "$BOOT_DIR" -type f -ls
  exit 1
fi

cp "$VMLINUX" "$PXE_DIR/vmlinuz"
cp "$INITRD" "$PXE_DIR/initrd"
cp "$TS_INTEGRATION/config/aurora-thinstation.ipxe" "$PXE_DIR/aurora-thinstation.ipxe"

if [ -f "$TS_INTEGRATION/config/thinstation.conf.network" ]; then
  cp "$TS_INTEGRATION/config/thinstation.conf.network" "$PXE_DIR/thinstation.conf.network"
fi

(
  cd "$PXE_DIR"
  sha256sum * > "$RELEASE_DIR/aurora-thinstation-pxe.sha256"
)

echo "Done. Artifacts:"
find "$RELEASE_DIR" -maxdepth 3 -type f -ls
