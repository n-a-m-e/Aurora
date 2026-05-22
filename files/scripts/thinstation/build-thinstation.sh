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
DISCOVERY_ROOT="$WORKDIR/discovery-chroot"
CACHE_DIR="$WORKDIR/cache"

PRUNE_RPM_FILES=(firmware system other)
PROTECT_RPM_FILES=(core grub kernel ts)

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
  iso-codes
  wget
  binutils
)

REQUIRED_PACKAGES=(
  coreutils
  file
  tar
  glib2
  util-linux
)

PROTECTED_RPMS=()
PROTECTED_PACKAGES=()
PROTECTED_MODULES=()
PROTECTED_FIRMWARE=()

MODULE_CACHE=""
FIRMWARE_CACHE=""
FW_OWNER_CACHE=""
ALLFIRMWARE=false

SUDO=""
[ "${EUID:-$(id -u)}" -eq 0 ] || SUDO="sudo"

clean_line() {
  sed -E 's/#.*$//; s/^[[:space:]]+//; s/[[:space:]]+$//'
}

has_item() {
  local wanted="$1"; shift
  local item
  for item in "$@"; do
    [ "$wanted" = "$item" ] && return 0
  done
  return 1
}

add_unique() {
  local kind="$1" value="$2" label="$3"
  local -n array="PROTECTED_${kind}"

  [ -z "$value" ] && return 0

  if ! has_item "$value" "${array[@]}"; then
    array+=("$value")
    echo "  protected $label: $value"
  fi
}

print_array() {
  local title="$1"; shift
  echo
  echo "$title:"
  [ "$#" -gt 0 ] && printf '  %s\n' "$@" | sort -u || echo "  <none>"
}

append_unique_lines() {
  local file="$1"; shift
  local item
  touch "$file"

  for item in "$@"; do
    [ -z "$item" ] && continue
    grep -qxF "$item" "$file" && echo "  already in $(basename "$file"): $item" && continue
    echo "$item" >> "$file"
    echo "  added to $(basename "$file"): $item"
  done
}

rpm_file_items() {
  local file="$1" line
  [ -f "$file" ] || return 0

  while read -r line || [ -n "$line" ]; do
    line="$(printf '%s\n' "$line" | clean_line)"
    [ -n "$line" ] && printf '%s\n' "$line"
  done < "$file"
}

conf_items() {
  local file="$1" line
  [ -f "$file" ] || return 0

  while read -r line || [ -n "$line" ]; do
    line="$(printf '%s\n' "$line" | clean_line)"
    [ -z "$line" ] && continue
    awk '{ printf "%s|%s|%s\n", $1, $2, $3 }' <<< "$line"
  done < "$file"
}

releasever() {
  . /etc/os-release
  echo "${VERSION_ID:-42}"
}

install_rpms() {
  local root="$1" source_file="$2" label="$3"
  local rpm rpms=()

  echo
  echo "Installing $label RPMs into discovery chroot..."

  while read -r rpm; do
    rpms+=("$rpm")
  done < <(rpm_file_items "$source_file")

  [ "${#rpms[@]}" -gt 0 ] || {
    echo "  no RPMs found for $label"
    return 0
  }

  mkdir -p "$root"

  $SUDO dnf install \
    --installroot "$root" \
    --releasever "$(releasever)" \
    --setopt=install_weak_deps=False \
    --setopt=keepcache=1 \
    -y \
    "${rpms[@]}"
}

kernel_version() {
  find "$DISCOVERY_ROOT/lib/modules" -mindepth 1 -maxdepth 1 -type d \
    | xargs -r -n1 basename \
    | sort \
    | tail -n1
}

set_cache_paths() {
  local kv="$1" fedora key

  fedora="$(sed -nE 's/.*\.fc([0-9]+)\..*/fc\1/p' <<< "$kv")"
  [ -n "$fedora" ] || fedora="unknown"

  key="thinstation-fw-map-${fedora}-$(uname -m)-${kv}"

  MODULE_CACHE="$CACHE_DIR/${key}-modules.txt"
  FIRMWARE_CACHE="$CACHE_DIR/${key}-firmware.txt"
  FW_OWNER_CACHE="$CACHE_DIR/${key}-firmware-owners.txt"

  echo "Kernel version: $kv"
  echo "Cache key:      $key"
}

create_caches() {
  local kv="$1" ko module depends fw file owner rel

  echo
  echo "Creating module/firmware caches for kernel: $kv"

  : > "$MODULE_CACHE"
  : > "$FIRMWARE_CACHE"

  while read -r ko; do
    module="$(basename "$ko")"
    module="${module%%.ko*}"

    depends="$(modinfo -F depends "$ko" 2>/dev/null | tr ',' ' ' | xargs || true)"

    printf '%s|%s|%s\n' "$module" "$ko" "$depends" >> "$MODULE_CACHE"

    while read -r fw || [ -n "$fw" ]; do
      [ -n "$fw" ] && printf '%s|%s\n' "$module" "$fw" >> "$FIRMWARE_CACHE"
    done < <(modinfo -F firmware "$ko" 2>/dev/null || true)
  done < <(find "$DISCOVERY_ROOT/lib/modules/$kv" -type f -name '*.ko*' | sort)

  sort -u "$MODULE_CACHE" -o "$MODULE_CACHE"
  sort -u "$FIRMWARE_CACHE" -o "$FIRMWARE_CACHE"

  echo
  echo "Creating firmware owner cache..."

  : > "$FW_OWNER_CACHE"

  while read -r file; do
    rel="${file#"$DISCOVERY_ROOT/usr/lib/firmware/"}"
    rel="${rel#"$DISCOVERY_ROOT/lib/firmware/"}"

    owner="$(
      rpm --root "$DISCOVERY_ROOT" -q --whatprovides "/usr/lib/firmware/$rel" \
        --queryformat '%{NAME}\n' 2>/dev/null \
      || rpm --root "$DISCOVERY_ROOT" -q --whatprovides "/lib/firmware/$rel" \
        --queryformat '%{NAME}\n' 2>/dev/null \
      || true
    )"

    [ -n "$owner" ] && printf '%s|%s\n' "$rel" "$owner" >> "$FW_OWNER_CACHE"
  done < <(
    find "$DISCOVERY_ROOT/usr/lib/firmware" "$DISCOVERY_ROOT/lib/firmware" \
      -type f 2>/dev/null | sort -u
  )

  sort -u "$FW_OWNER_CACHE" -o "$FW_OWNER_CACHE"
}

prepare_discovery_cache() {
  local kv rpm

  while read -r rpm; do
    add_unique RPMS "$rpm" rpm
  done < <(rpm_file_items "$TS_SRC/ts/rpms/kernel")

  install_rpms "$DISCOVERY_ROOT" "$TS_SRC/ts/rpms/kernel" kernel

  kv="$(kernel_version)"
  [ -n "$kv" ] || {
    echo "Could not determine kernel version in discovery chroot"
    exit 1
  }

  mkdir -p "$CACHE_DIR"
  set_cache_paths "$kv"

  if [ -f "$MODULE_CACHE" ] && [ -f "$FIRMWARE_CACHE" ] && [ -f "$FW_OWNER_CACHE" ]; then
    echo "Discovery caches already exist."
    return 0
  fi

  echo "Discovery caches missing; installing firmware RPMs and creating caches."
  install_rpms "$DISCOVERY_ROOT" "$TS_SRC/ts/rpms/firmware" firmware
  create_caches "$kv"

  install_rpms "$DISCOVERY_ROOT" "$TS_SRC/ts/rpms/kernel" kernel
  kv="$(kernel_version)"
  [ -n "$kv" ] || {
    echo "Could not determine kernel version after cache creation"
    exit 1
  }

  set_cache_paths "$kv"

  [ -f "$MODULE_CACHE" ] && [ -f "$FIRMWARE_CACHE" ] && [ -f "$FW_OWNER_CACHE" ] || {
    echo "Cache files still missing after creation"
    exit 1
  }
}

protect_firmware_file() {
  local fw="$1" rpm

  add_unique FIRMWARE "$fw" firmware

  while read -r rpm; do
    [ -n "$rpm" ] && add_unique RPMS "$rpm" rpm
  done < <(awk -F'|' -v fw="$fw" '$1 == fw { print $2 }' "$FW_OWNER_CACHE" | sort -u)

  add_unique RPMS linux-firmware-whence rpm
}

module_line() {
  local module="$1" alt="${module//-/_}"
  awk -F'|' -v m="$module" -v a="$alt" '$1 == m || $1 == a { print; exit }' "$MODULE_CACHE"
}

handle_conf_item() {
  local first="$1" second="$2" third="$3"

  case "$first" in
    package|pkg) protect_package_tree "$second" ;;
    module|module_pkg) protect_module_tree "$second" ;;
    firmware) protect_firmware_file "$second" ;;
    machine) protect_machine "$second" ;;
    param)
      if [ "$second" = "allfirmware" ] && [ "$third" = "true" ]; then
        ALLFIRMWARE=true
        echo "  allfirmware enabled"
      fi
      ;;
  esac
}

protect_module_dependency_file() {
  local module="$1" first second third
  while IFS='|' read -r first second third; do
    handle_conf_item "$first" "$second" "$third"
  done < <(conf_items "$TS_SRC/ts/build/kernel/dependencies_module/$module")
}

protect_module_tree() {
  local module="$1" line deps dep fw rpm

  [ -z "$module" ] && return 0
  has_item "$module" "${PROTECTED_MODULES[@]}" && return 0

  add_unique MODULES "$module" module

  while read -r rpm; do
    add_unique RPMS "$rpm" rpm
  done < <(rpm_file_items "$TS_SRC/ts/rpms/kernel")

  line="$(module_line "$module" || true)"
  deps="$(awk -F'|' '{print $3}' <<< "$line")"

  for dep in $deps; do
    protect_module_tree "$dep"
  done

  protect_module_dependency_file "$module"

  if [ "$ALLFIRMWARE" = true ]; then
    while read -r fw; do
      [ -n "$fw" ] && protect_firmware_file "$fw"
    done < <(
      awk -F'|' -v m="$module" -v a="${module//-/_}" '$1 == m || $1 == a { print $2 }' "$FIRMWARE_CACHE"
    )
  fi
}

protect_package_rpms() {
  local pkg="$1" file="$TS_SRC/ts/build/packages/$pkg/build/install" rpm

  [ -f "$file" ] || return 0

  while read -r rpm; do
    [ -n "$rpm" ] && add_unique RPMS "$rpm" rpm
  done < <(
    grep -E '^[[:space:]]*(export[[:space:]]+)?PORTS=' "$file" \
      | sed -E 's/.*PORTS="//; s/".*//' \
      | tr ' ' '\n'
  )
}

protect_package_tree() {
  local pkg="$1" dep

  [ -z "$pkg" ] && return 0
  has_item "$pkg" "${PROTECTED_PACKAGES[@]}" && return 0

  add_unique PACKAGES "$pkg" package
  protect_package_rpms "$pkg"

  while read -r dep || [ -n "$dep" ]; do
    dep="$(printf '%s\n' "$dep" | clean_line)"
    [ -n "$dep" ] && protect_package_tree "$dep"
  done < "$TS_SRC/ts/build/packages/$pkg/dependencies" 2>/dev/null || true

  while read -r dep || [ -n "$dep" ]; do
    dep="$(printf '%s\n' "$dep" | clean_line)"
    [ -n "$dep" ] && protect_module_tree "$dep"
  done < "$TS_SRC/ts/build/kernel/dependencies_package/$pkg" 2>/dev/null || true
}

parse_file() {
  local file="$1" mode="$2" first second third value

  while IFS='|' read -r first second third; do
    [ -z "$first" ] && continue

    case "$mode:$first" in
      package:package|package:pkg|module:module|module:module_pkg|firmware:firmware)
        value="$second"
        ;;
      *)
        value="$first"
        ;;
    esac

    case "$mode" in
      package) protect_package_tree "$value" ;;
      module) protect_module_tree "$value" ;;
      firmware) protect_firmware_file "$value" ;;
    esac
  done < <(conf_items "$file")
}

protect_machine() {
  local machine="$1" dir="$TS_SRC/ts/build/machine/$machine"

  echo "Protecting machine profile: $machine"

  [ -d "$dir" ] || {
    echo "  machine not found: $machine"
    return 0
  }

  parse_file "$dir/module.list" module
  parse_file "$dir/firmware.list" firmware
  parse_file "$dir/package.list" package
}

parse_build_conf() {
  local file="$1" first second third

  echo
  echo "Reading build.conf: $file"

  while IFS='|' read -r first second third; do
    handle_conf_item "$first" "$second" "$third"
  done < <(conf_items "$file")
}

append_protected_rpms_to_system() {
  echo
  echo "Appending protected RPMs to ts/rpms/system..."
  append_unique_lines "$TS_SRC/ts/rpms/system" "${PROTECTED_RPMS[@]}"
}

prune_rpm_lists() {
  local name file tmp line kept removed

  echo
  echo "Pruning RPM lists: ${PRUNE_RPM_FILES[*]}"

  for name in "${PRUNE_RPM_FILES[@]}"; do
    file="$TS_SRC/ts/rpms/$name"
    [ -f "$file" ] || continue

    tmp="$(mktemp)"
    kept=0
    removed=0

    while read -r line || [ -n "$line" ]; do
      line="$(printf '%s\n' "$line" | clean_line)"

      if [ -z "$line" ]; then
        echo "$line" >> "$tmp"
      elif has_item "$line" "${PROTECTED_RPMS[@]}"; then
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

prune_package_dirs() {
  local root="$TS_SRC/ts/build/packages"
  local dir pkg kept=0 removed=0

  echo
  echo "Pruning ThinStation package directories..."

  while read -r dir; do
    pkg="$(basename "$dir")"

    if has_item "$pkg" "${PROTECTED_PACKAGES[@]}"; then
      kept=$((kept + 1))
    else
      rm -rf "$dir"
      echo "  removed from packages: $pkg"
      removed=$((removed + 1))
    fi
  done < <(find "$root" -mindepth 1 -maxdepth 1 -type d | sort)

  echo "  packages: kept $kept, removed $removed"
}

copy_config() {
  echo
  echo "Copying Aurora ThinStation config..."

  cp "$TS_INTEGRATION/config/build.conf" "$TS_SRC/ts/build/build.conf"
  cp "$TS_INTEGRATION/config/thinstation.conf.buildtime" "$TS_SRC/ts/build/thinstation.conf.buildtime"

  [ ! -f "$TS_INTEGRATION/config/thinstation.conf.network" ] || \
    cp "$TS_INTEGRATION/config/thinstation.conf.network" "$TS_SRC/ts/build/thinstation.conf.network"
}

validate_build_conf_packages() {
  local pkg missing=()

  echo
  echo "Validating selected build.conf packages..."

  while read -r pkg; do
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
}

collect_artifacts() {
  local boot_dir="$TS_SRC/ts/build/boot-images/initrd"
  local vmlinuz initrd

  echo
  echo "Collecting PXE artifacts..."

  [ -d "$boot_dir" ] || {
    echo "Expected boot output directory not found: $boot_dir"
    find "$TS_SRC/ts/build/boot-images" -maxdepth 4 -type f -ls || true
    exit 1
  }

  vmlinuz="$(find "$boot_dir" -type f \( -name 'vmlinuz' -o -name 'vmlinuz-*' \) | head -n1)"
  initrd="$(find "$boot_dir" -type f \( -name 'initrd' -o -name 'initrd.img' -o -name 'initrd-*' \) | head -n1)"

  [ -n "$vmlinuz" ] && [ -n "$initrd" ] || {
    echo "Could not find vmlinuz/initrd in $boot_dir"
    find "$boot_dir" -type f -ls
    exit 1
  }

  cp "$vmlinuz" "$PXE_DIR/vmlinuz"
  cp "$initrd" "$PXE_DIR/initrd"
  cp "$TS_INTEGRATION/config/aurora-thinstation.ipxe" "$PXE_DIR/aurora-thinstation.ipxe"

  [ ! -f "$TS_INTEGRATION/config/thinstation.conf.network" ] || \
    cp "$TS_INTEGRATION/config/thinstation.conf.network" "$PXE_DIR/thinstation.conf.network"

  (
    cd "$PXE_DIR"
    sha256sum * > "$RELEASE_DIR/aurora-thinstation-pxe.sha256"
  )
}

echo "Root:             $ROOT"
echo "Workdir:          $WORKDIR"
echo "ThinStation ref:  $TS_REF"
echo "Release dir:      $RELEASE_DIR"

rm -rf "$WORKDIR" "$RELEASE_DIR"
mkdir -p "$WORKDIR" "$PXE_DIR" "$CACHE_DIR"

echo
echo "Cloning ThinStation..."
git clone "$TS_REPO" "$TS_SRC"
cd "$TS_SRC"

echo "Checking out ThinStation ref..."
git fetch --all --tags --prune
git checkout "$TS_REF"
git reset --hard "$TS_REF"

echo
echo "Protecting build-required RPMs..."
for rpm in "${REQUIRED_RPMS[@]}"; do
  add_unique RPMS "$rpm" rpm
done

echo
echo "Protecting required ThinStation packages..."
for pkg in "${REQUIRED_PACKAGES[@]}"; do
  protect_package_tree "$pkg"
done

echo
echo "Protecting RPMs from protected RPM files: ${PROTECT_RPM_FILES[*]}"
for name in "${PROTECT_RPM_FILES[@]}"; do
  while read -r rpm; do
    add_unique RPMS "$rpm" rpm
  done < <(rpm_file_items "$TS_SRC/ts/rpms/$name")
done

prepare_discovery_cache
parse_build_conf "$TS_INTEGRATION/config/build.conf"

if [ "$ALLFIRMWARE" = true ]; then
  echo
  echo "Protecting firmware for all protected modules..."
  for module in "${PROTECTED_MODULES[@]}"; do
    while read -r fw; do
      [ -n "$fw" ] && protect_firmware_file "$fw"
    done < <(
      awk -F'|' -v m="$module" -v a="${module//-/_}" '$1 == m || $1 == a { print $2 }' "$FIRMWARE_CACHE"
    )
  done
fi

print_array "Final protected RPMs" "${PROTECTED_RPMS[@]}"
print_array "Final protected ThinStation packages" "${PROTECTED_PACKAGES[@]}"
print_array "Final protected modules" "${PROTECTED_MODULES[@]}"
print_array "Final protected firmware" "${PROTECTED_FIRMWARE[@]}"

append_protected_rpms_to_system
prune_rpm_lists
prune_package_dirs
copy_config
validate_build_conf_packages

echo
echo "Preparing ThinStation chroot..."
sudo ./setup-chroot -i

echo
echo "Building ThinStation PXE artifacts..."
sudo ./setup-chroot -a -b -o --license ACCEPT

collect_artifacts

echo
echo "Done. Artifacts:"
find "$RELEASE_DIR" -maxdepth 3 -type f -ls
