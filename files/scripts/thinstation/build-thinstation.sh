#!/usr/bin/env bash
set -euo pipefail

ROOT="${AURORA_ROOT:-${GITHUB_WORKSPACE:-$(pwd)}}"
ROOT="$(cd "$ROOT" && pwd)"

TS_INTEGRATION="$ROOT/files/scripts/thinstation"
WORKDIR="${WORKDIR:-$ROOT/.build/thinstation}"
TS_SRC="$WORKDIR/thinstation-ng"
TS_REF="$(cat "$TS_INTEGRATION/THINSTATION_REF")"
TS_REPO="https://github.com/Thinstation/thinstation-ng.git"

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

clean() { sed -E 's/#.*$//; s/^[[:space:]]+//; s/[[:space:]]+$//'; }

has() {
  local item="$1"; shift
  local x
  for x in "$@"; do [ "$item" = "$x" ] && return 0; done
  return 1
}

add() {
  local kind="$1" value="$2" label="$3"
  local -n arr="PROTECTED_${kind}"

  [ -z "$value" ] && return 0
  has "$value" "${arr[@]}" && return 0

  arr+=("$value")
  echo "  protected $label: $value"
}

list_file() {
  local file="$1" line
  [ -f "$file" ] || return 0

  while read -r line || [ -n "$line" ]; do
    line="$(printf '%s\n' "$line" | clean)"
    [ -n "$line" ] && printf '%s\n' "$line"
  done < "$file"
}

conf_file() {
  local file="$1" line
  [ -f "$file" ] || return 0

  while read -r line || [ -n "$line" ]; do
    line="$(printf '%s\n' "$line" | clean)"
    [ -n "$line" ] && awk '{ printf "%s|%s|%s\n", $1, $2, $3 }' <<< "$line"
  done < "$file"
}

install_list() {
  local file="$1" label="$2" rpm rpms=()

  while read -r rpm; do rpms+=("$rpm"); done < <(list_file "$file")
  [ "${#rpms[@]}" -gt 0 ] || return 0

  echo
  echo "Installing $label RPMs into discovery chroot..."

  local args=(
    install
    --installroot "$DISCOVERY_ROOT"
    --use-host-config
    --setopt=install_weak_deps=False
    --setopt=keepcache=1
    -y
  )

  # First kernel install has no kernel path yet; later installs derive releasever from it.
  if [ "$label" != "kernel" ] || [ -d "$DISCOVERY_ROOT/lib/modules" ]; then
    args+=(--releasever "$(releasever)")
  fi

  mkdir -p "$DISCOVERY_ROOT"
  $SUDO dnf "${args[@]}" "${rpms[@]}"
}

kernel_version() {
  find "$DISCOVERY_ROOT/lib/modules" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
    | xargs -r -n1 basename \
    | sort \
    | tail -n1
}

releasever() {
  local kv fedora
  kv="$(kernel_version)"
  fedora="$(sed -nE 's/.*\.fc([0-9]+)\..*/\1/p' <<< "$kv")"

  [ -n "$fedora" ] || {
    echo "Could not derive Fedora release from $DISCOVERY_ROOT/lib/modules" >&2
    exit 1
  }

  echo "$fedora"
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
  local kv="$1" ko mod deps fw file rel owner

  echo
  echo "Creating module, firmware, and owner caches..."

  : > "$MODULE_CACHE"
  : > "$FIRMWARE_CACHE"
  : > "$FW_OWNER_CACHE"

  while read -r ko; do
    mod="$(basename "$ko")"
    mod="${mod%%.ko*}"
    deps="$(modinfo -F depends "$ko" 2>/dev/null | tr ',' ' ' | xargs || true)"

    printf '%s|%s|%s\n' "$mod" "$ko" "$deps" >> "$MODULE_CACHE"

    while read -r fw || [ -n "$fw" ]; do
      [ -n "$fw" ] && printf '%s|%s\n' "$mod" "$fw" >> "$FIRMWARE_CACHE"
    done < <(modinfo -F firmware "$ko" 2>/dev/null || true)
  done < <(find "$DISCOVERY_ROOT/lib/modules/$kv" -type f -name '*.ko*' | sort)

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

  sort -u "$MODULE_CACHE" -o "$MODULE_CACHE"
  sort -u "$FIRMWARE_CACHE" -o "$FIRMWARE_CACHE"
  sort -u "$FW_OWNER_CACHE" -o "$FW_OWNER_CACHE"
}

prepare_cache() {
  local kv rpm

  while read -r rpm; do add RPMS "$rpm" rpm; done < <(list_file "$TS_SRC/ts/rpms/kernel")

  install_list "$TS_SRC/ts/rpms/kernel" kernel

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
  install_list "$TS_SRC/ts/rpms/firmware" firmware
  create_caches "$kv"

  install_list "$TS_SRC/ts/rpms/kernel" kernel
  kv="$(kernel_version)"
  [ -n "$kv" ] || {
    echo "Could not determine kernel version after cache creation"
    exit 1
  }

  set_cache_paths "$kv"
}

protect_firmware() {
  local fw="$1" rpm

  add FIRMWARE "$fw" firmware

  while read -r rpm; do
    [ -n "$rpm" ] && add RPMS "$rpm" rpm
  done < <(awk -F'|' -v fw="$fw" '$1 == fw { print $2 }' "$FW_OWNER_CACHE" | sort -u)

  add RPMS linux-firmware-whence rpm
}

module_line() {
  local mod="$1" alt="${1//-/_}"
  awk -F'|' -v m="$mod" -v a="$alt" '$1 == m || $1 == a { print; exit }' "$MODULE_CACHE"
}

handle_config_item() {
  local key="$1" value="$2" arg="$3"

  case "$key" in
    package|pkg) protect_package "$value" ;;
    module|module_pkg) protect_module "$value" ;;
    firmware) protect_firmware "$value" ;;
    machine) protect_machine "$value" ;;
    param)
      if [ "$value" = "allfirmware" ] && [ "$arg" = "true" ]; then
        ALLFIRMWARE=true
        echo "  allfirmware enabled"
      fi
      ;;
  esac
}

protect_module() {
  local mod="$1" line deps dep fw rpm

  [ -z "$mod" ] && return 0
  has "$mod" "${PROTECTED_MODULES[@]}" && return 0

  add MODULES "$mod" module

  while read -r rpm; do add RPMS "$rpm" rpm; done < <(list_file "$TS_SRC/ts/rpms/kernel")

  line="$(module_line "$mod" || true)"
  deps="$(awk -F'|' '{print $3}' <<< "$line")"

  for dep in $deps; do protect_module "$dep"; done

  while IFS='|' read -r key value arg; do
    handle_config_item "$key" "$value" "$arg"
  done < <(conf_file "$TS_SRC/ts/build/kernel/dependencies_module/$mod")

  [ "$ALLFIRMWARE" = true ] || return 0

  while read -r fw; do
    [ -n "$fw" ] && protect_firmware "$fw"
  done < <(awk -F'|' -v m="$mod" -v a="${mod//-/_}" '$1 == m || $1 == a { print $2 }' "$FIRMWARE_CACHE")
}

protect_package_rpms() {
  local pkg="$1" file="$TS_SRC/ts/build/packages/$pkg/build/install" rpm

  [ -f "$file" ] || return 0

  while read -r rpm; do
    [ -n "$rpm" ] && add RPMS "$rpm" rpm
  done < <(
    grep -E '^[[:space:]]*(export[[:space:]]+)?PORTS=' "$file" 2>/dev/null \
      | sed -E 's/.*PORTS="//; s/".*//' \
      | tr ' ' '\n' \
      || true
  )

  return 0
}

protect_package() {
  local pkg="$1" dep file

  [ -z "$pkg" ] && return 0
  has "$pkg" "${PROTECTED_PACKAGES[@]}" && return 0

  add PACKAGES "$pkg" package
  protect_package_rpms "$pkg"

  file="$TS_SRC/ts/build/packages/$pkg/dependencies"
  if [ -f "$file" ]; then
    while read -r dep || [ -n "$dep" ]; do
      dep="$(printf '%s\n' "$dep" | clean)"
      [ -n "$dep" ] && protect_package "$dep"
    done < "$file"
  fi

  file="$TS_SRC/ts/build/kernel/dependencies_package/$pkg"
  if [ -f "$file" ]; then
    while read -r dep || [ -n "$dep" ]; do
      dep="$(printf '%s\n' "$dep" | clean)"
      [ -n "$dep" ] && protect_module "$dep"
    done < "$file"
  fi

  return 0
}

parse_mode_file() {
  local file="$1" mode="$2" key value arg selected

  while IFS='|' read -r key value arg; do
    [ -z "$key" ] && continue

    case "$mode:$key" in
      package:package|package:pkg|module:module|module:module_pkg|firmware:firmware)
        selected="$value"
        ;;
      *)
        selected="$key"
        ;;
    esac

    case "$mode" in
      package) protect_package "$selected" ;;
      module) protect_module "$selected" ;;
      firmware) protect_firmware "$selected" ;;
    esac
  done < <(conf_file "$file")
}

protect_machine() {
  local machine="$1" dir="$TS_SRC/ts/build/machine/$machine"

  echo "Protecting machine profile: $machine"

  [ -d "$dir" ] || {
    echo "  machine not found: $machine"
    return 0
  }

  parse_mode_file "$dir/module.list" module
  parse_mode_file "$dir/firmware.list" firmware
  parse_mode_file "$dir/package.list" package
}

parse_build_conf() {
  local key value arg

  echo
  echo "Reading build.conf: $TS_INTEGRATION/config/build.conf"

  while IFS='|' read -r key value arg; do
    handle_config_item "$key" "$value" "$arg"
  done < <(conf_file "$TS_INTEGRATION/config/build.conf")
}

append_protected_rpms() {
  local rpm file="$TS_SRC/ts/rpms/system"

  echo
  echo "Appending protected RPMs to ts/rpms/system..."

  touch "$file"

  for rpm in "${PROTECTED_RPMS[@]}"; do
    grep -qxF "$rpm" "$file" || {
      echo "$rpm" >> "$file"
      echo "  added to system: $rpm"
    }
  done
}

prune_rpms() {
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
      line="$(printf '%s\n' "$line" | clean)"

      if [ -z "$line" ]; then
        echo "$line" >> "$tmp"
      elif has "$line" "${PROTECTED_RPMS[@]}"; then
        echo "$line" >> "$tmp"
        kept=$((kept + 1))
      else
        removed=$((removed + 1))
      fi
    done < "$file"

    mv "$tmp" "$file"
    echo "  $name: kept $kept, removed $removed"
  done
}

prune_packages() {
  local dir pkg kept=0 removed=0

  echo
  echo "Pruning ThinStation package directories..."

  while read -r dir; do
    pkg="$(basename "$dir")"

    if has "$pkg" "${PROTECTED_PACKAGES[@]}"; then
      kept=$((kept + 1))
    else
      rm -rf "$dir"
      removed=$((removed + 1))
    fi
  done < <(find "$TS_SRC/ts/build/packages" -mindepth 1 -maxdepth 1 -type d | sort)

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

validate_packages() {
  local pkg missing=()

  echo
  echo "Validating selected build.conf packages..."

  while read -r pkg; do
    [ -d "$TS_SRC/ts/build/packages/$pkg" ] || missing+=("$pkg")
  done < <(sed 's/#.*$//' "$TS_SRC/ts/build/build.conf" | awk '$1 == "package" || $1 == "pkg" { print $2 }')

  [ "${#missing[@]}" -eq 0 ] || {
    echo "Missing selected packages after pruning:"
    printf '  %s\n' "${missing[@]}"
    exit 1
  }
}

collect_artifacts() {
  local boot_dir="$TS_SRC/ts/build/boot-images/initrd" vmlinuz initrd

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

  (cd "$PXE_DIR" && sha256sum * > "$RELEASE_DIR/aurora-thinstation-pxe.sha256")
}

print_final_lists() {
  echo
  echo "Final protected RPMs:"
  printf '  %s\n' "${PROTECTED_RPMS[@]}" | sort -u

  echo
  echo "Final protected ThinStation packages:"
  printf '  %s\n' "${PROTECTED_PACKAGES[@]}" | sort -u

  echo
  echo "Final protected modules:"
  printf '  %s\n' "${PROTECTED_MODULES[@]}" | sort -u

  echo
  echo "Final protected firmware:"
  printf '  %s\n' "${PROTECTED_FIRMWARE[@]}" | sort -u
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
for rpm in "${REQUIRED_RPMS[@]}"; do add RPMS "$rpm" rpm; done

echo
echo "Protecting required ThinStation packages..."
for pkg in "${REQUIRED_PACKAGES[@]}"; do protect_package "$pkg"; done

echo
echo "Protecting RPMs from protected RPM files: ${PROTECT_RPM_FILES[*]}"
for name in "${PROTECT_RPM_FILES[@]}"; do
  while read -r rpm; do add RPMS "$rpm" rpm; done < <(list_file "$TS_SRC/ts/rpms/$name")
done

prepare_cache
parse_build_conf

if [ "$ALLFIRMWARE" = true ]; then
  echo
  echo "Protecting firmware for all protected modules..."
  for module in "${PROTECTED_MODULES[@]}"; do
    while read -r fw; do
      [ -n "$fw" ] && protect_firmware "$fw"
    done < <(awk -F'|' -v m="$module" -v a="${module//-/_}" '$1 == m || $1 == a { print $2 }' "$FIRMWARE_CACHE")
  done
fi

print_final_lists
append_protected_rpms
prune_rpms
prune_packages
copy_config
validate_packages

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
