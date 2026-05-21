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

RPM_FILES=(firmware system other)

# Always keep packages that provide ThinStation build-system requirements
# or core runtime/build functionality.
PROTECTED_PACKAGES=(
  coreutils
  file
  tar
  xorriso
  squashfs-tools
  glib2
  glib2-devel
  librsvg2-tools
  ImageMagick
  tigervnc-server-minimal
  samba-common-tools
  which
  util-linux
  util-linux-core
)

is_protected_package() {
  local pkg="$1"
  local protected

  for protected in "${PROTECTED_PACKAGES[@]}"; do
    if [ "$pkg" = "$protected" ]; then
      return 0
    fi
  done

  return 1
}

protect_package_tree() {
  local pkg="$1"
  local dep_file
  local dep

  [ -z "$pkg" ] && return 0

  if is_protected_package "$pkg"; then
    return 0
  fi

  PROTECTED_PACKAGES+=("$pkg")
  echo "  protected: $pkg"

  dep_file="$TS_SRC/ts/build/packages/$pkg/dependencies"

  if [ -f "$dep_file" ]; then
    while read -r dep; do
      dep="$(echo "$dep" | sed -E 's/#.*$//; s/^[[:space:]]+//; s/[[:space:]]+$//')"
      [ -z "$dep" ] && continue
      protect_package_tree "$dep"
    done < "$dep_file"
  fi
}

extend_protected_packages_from_build_conf() {
  local build_conf="$1"
  local selected_pkg

  if [ ! -f "$build_conf" ]; then
    echo "Build config not found for protected-package scan: $build_conf"
    return 0
  fi

  echo "Protecting packages selected in build.conf and dependency tree:"

  while read -r selected_pkg; do
    [ -z "$selected_pkg" ] && continue
    protect_package_tree "$selected_pkg"
  done < <(
    sed 's/#.*$//' "$build_conf" \
      | awk '$1 == "package" || $1 == "pkg" { print $2 }'
  )
}

trim_file_in_place() {
  local file="$1"
  local tmp

  tmp="$(mktemp)"
  sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' "$file" > "$tmp"
  mv "$tmp" "$file"
}

prune_unprotected_rpm_lists() {
  local name
  local file
  local tmp
  local line
  local kept
  local removed

  echo
  echo "Pruning RPM lists to protected packages only..."

  for name in "${RPM_FILES[@]}"; do
    file="$TS_SRC/ts/rpms/$name"
    [ -f "$file" ] || continue

    trim_file_in_place "$file"

    tmp="$(mktemp)"
    kept=0
    removed=0

    while IFS= read -r line || [ -n "$line" ]; do
      # Keep comments and blanks.
      if [ -z "$line" ] || [[ "$line" =~ ^# ]]; then
        echo "$line" >> "$tmp"
        continue
      fi

      if is_protected_package "$line"; then
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
}

prune_unprotected_package_dirs() {
  local package_root
  local dir
  local pkg
  local kept=0
  local removed=0

  package_root="$TS_SRC/ts/build/packages"

  echo
  echo "Pruning ThinStation package directories to protected packages only..."

  if [ ! -d "$package_root" ]; then
    echo "Package directory not found: $package_root"
    exit 1
  fi

  while IFS= read -r dir; do
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
}

print_protected_packages() {
  echo
  echo "Final protected package list:"
  printf '  %s\n' "${PROTECTED_PACKAGES[@]}" | sort -u
}

validate_selected_packages_exist() {
  local build_conf="$1"
  local selected_pkg
  local missing_packages=()

  echo
  echo "Validating selected build.conf packages after pruning..."

  while read -r selected_pkg; do
    [ -z "$selected_pkg" ] && continue

    if [ ! -d "$TS_SRC/ts/build/packages/$selected_pkg" ]; then
      missing_packages+=("$selected_pkg")
    fi
  done < <(
    sed 's/#.*$//' "$build_conf" \
      | awk '$1 == "package" || $1 == "pkg" { print $2 }'
  )

  if [ "${#missing_packages[@]}" -gt 0 ]; then
    echo "The following selected packages are missing after pruning:"
    printf '  %s\n' "${missing_packages[@]}"
    exit 1
  fi

  echo "All selected build.conf packages are present."
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

echo "Preparing protected package list..."
extend_protected_packages_from_build_conf "$TS_INTEGRATION/config/build.conf"
print_protected_packages

echo "Pruning ThinStation package inputs..."
prune_unprotected_rpm_lists
prune_unprotected_package_dirs

echo "Copying Aurora ThinStation config..."
cp "$TS_INTEGRATION/config/build.conf" \
   "$TS_SRC/ts/build/build.conf"

cp "$TS_INTEGRATION/config/thinstation.conf.buildtime" \
   "$TS_SRC/ts/build/thinstation.conf.buildtime"

if [ -f "$TS_INTEGRATION/config/thinstation.conf.network" ]; then
  cp "$TS_INTEGRATION/config/thinstation.conf.network" \
     "$TS_SRC/ts/build/thinstation.conf.network"
fi

validate_selected_packages_exist "$TS_SRC/ts/build/build.conf"

echo "Preparing ThinStation chroot..."
sudo ./setup-chroot -i

echo "Building ThinStation PXE artifacts..."
sudo ./setup-chroot -a -b -o --license ACCEPT

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
