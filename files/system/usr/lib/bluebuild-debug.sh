#!/usr/bin/env bash
set -Eeuo pipefail

[[ "${BLUEBUILD_DEBUG_LOADED:-}" == "1" ]] && return 0
export BLUEBUILD_DEBUG_LOADED=1

SCRIPT_NAME="$(basename "${BASH_SOURCE[1]}" .sh)"
LOG_DIR="${BB_DEBUG_LOG_DIR:-/var/log/bluebuild-debug}"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}.log"

mkdir -p "$LOG_DIR"

BB_DEBUG_XTRACE="${BB_DEBUG_XTRACE:-0}"
BB_DEBUG_LARGE_FILE_MB="${BB_DEBUG_LARGE_FILE_MB:-50}"
BB_DEBUG_TREE_MIN_MB="${BB_DEBUG_TREE_MIN_MB:-50}"
BB_DEBUG_TREE_MAX_DEPTH="${BB_DEBUG_TREE_MAX_DEPTH:-5}"
BB_DEBUG_NEW_PATH_LIMIT="${BB_DEBUG_NEW_PATH_LIMIT:-1500}"
BB_DEBUG_TOP_RPM_LIMIT="${BB_DEBUG_TOP_RPM_LIMIT:-80}"

BB_DEBUG_AUTO_CLEAN_TMP="${BB_DEBUG_AUTO_CLEAN_TMP:-0}"
BB_DEBUG_CLEAN_TMP_ROOTS="${BB_DEBUG_CLEAN_TMP_ROOTS:-}"

_BB_BEFORE_FILES="$(mktemp)"
_BB_AFTER_FILES="$(mktemp)"
_BB_BEFORE_SIZES="$(mktemp)"
_BB_AFTER_SIZES="$(mktemp)"
_BB_BEFORE_RPM_NAMES="$(mktemp)"
_BB_AFTER_RPM_NAMES="$(mktemp)"
_BB_BEFORE_RPM_SIZES="$(mktemp)"
_BB_AFTER_RPM_SIZES="$(mktemp)"

bb_debug_snapshot_files() {
  find /tmp /var/tmp /opt /usr /var /etc /root \
    -xdev \( -type f -o -type d -o -type l \) \
    2>/dev/null | sort
}

bb_debug_top_level_sizes() {
  du -xhd1 /tmp /var/tmp /opt /usr /var /etc /root 2>/dev/null | sort -h
}

bb_debug_rpm_names() {
  command -v rpm >/dev/null 2>&1 || return 0
  rpm -qa --qf '%{NAME}\n' 2>/dev/null | sort
}

bb_debug_rpm_sizes() {
  command -v rpm >/dev/null 2>&1 || return 0
  rpm -qa --qf '%{SIZE}\t%{NAME}\n' 2>/dev/null | sort -n
}

bb_debug_top_rpms() {
  command -v rpm >/dev/null 2>&1 || return 0
  rpm -qa --qf '%{SIZE}\t%{NAME}\n' 2>/dev/null | sort -n | tail -n "$BB_DEBUG_TOP_RPM_LIMIT"
}

bb_debug_new_rpms_with_sizes() {
  command -v rpm >/dev/null 2>&1 || return 0
  comm -13 "$_BB_BEFORE_RPM_NAMES" "$_BB_AFTER_RPM_NAMES" | while read -r pkg; do
    rpm -q --qf '%{SIZE}\t%{NAME}\n' "$pkg" 2>/dev/null || true
  done | sort -n
}

bb_debug_large_files() {
  find /tmp /var/tmp /opt /usr /var /etc /root \
    -xdev -type f -size +"${BB_DEBUG_LARGE_FILE_MB}"M \
    -printf '%s\t%p\n' 2>/dev/null | sort -n
}

bb_debug_new_large_files() {
  local min_bytes=$((BB_DEBUG_LARGE_FILE_MB * 1024 * 1024))
  comm -13 "$_BB_BEFORE_FILES" "$_BB_AFTER_FILES" | while read -r path; do
    [[ -f "$path" ]] || continue
    size="$(stat -c '%s' "$path" 2>/dev/null || echo 0)"
    [[ "$size" -ge "$min_bytes" ]] || continue
    printf '%s\t%s\n' "$size" "$path"
  done | sort -n
}

bb_debug_suspicious_files() {
  find /tmp /var/tmp /opt /usr /var /etc /root \
    -xdev -type f \
    \( -iname '*.zip' -o -iname '*.tar' -o -iname '*.tar.gz' -o -iname '*.tgz' \
    -o -iname '*.tar.xz' -o -iname '*.txz' -o -iname '*.rpm' -o -iname '*.deb' \
    -o -iname '*.AppImage' -o -iname '*.run' -o -iname '*.iso' -o -iname '*.7z' \
    -o -iname '*.rar' -o -iname '*.xz' -o -iname '*.zst' \) \
    -printf '%s\t%p\n' 2>/dev/null | sort -n
}

bb_debug_new_suspicious_files() {
  comm -13 "$_BB_BEFORE_FILES" "$_BB_AFTER_FILES" | while read -r path; do
    [[ -f "$path" ]] || continue
    case "${path,,}" in
      *.zip|*.tar|*.tar.gz|*.tgz|*.tar.xz|*.txz|*.rpm|*.deb|*.appimage|*.run|*.iso|*.7z|*.rar|*.xz|*.zst)
        size="$(stat -c '%s' "$path" 2>/dev/null || echo 0)"
        printf '%s\t%s\n' "$size" "$path"
        ;;
    esac
  done | sort -n
}

bb_debug_cache_dirs() {
  du -xsh /tmp /var/tmp /var/cache /var/lib/dnf /var/lib/rpm-ostree \
    /var/lib/containers /var/log /root/.cache /root/.local /usr/tmp \
    2>/dev/null | sort -h || true
}

bb_debug_large_directory_tree() {
  local root="${1:-/}"
  local min_mb="${2:-$BB_DEBUG_TREE_MIN_MB}"
  local max_depth="${3:-$BB_DEBUG_TREE_MAX_DEPTH}"
  local min_bytes=$((min_mb * 1024 * 1024))

  [[ -d "$root" ]] || return 0

  echo "Large directory tree for: $root"
  echo "Minimum size: ${min_mb}MB"
  echo "Maximum depth: ${max_depth}"
  echo

  find "$root" -xdev -type d 2>/dev/null | while read -r dir; do
    rel="${dir#$root}"
    rel="${rel#/}"

    depth=0
    if [[ -n "$rel" ]]; then
      depth=$(( $(grep -o "/" <<< "$rel" | wc -l) + 1 ))
    fi

    [[ "$depth" -le "$max_depth" ]] || continue

    bytes="$(du -xsb "$dir" 2>/dev/null | awk '{print $1}')"
    [[ -n "$bytes" ]] || continue
    [[ "$bytes" -ge "$min_bytes" ]] || continue

    human="$(du -xsh "$dir" 2>/dev/null | awk '{print $1}')"
    indent="$(printf '%*s' $((depth * 2)) '')"

    if [[ "$dir" == "$root" ]]; then
      label="$root"
    else
      label="$(basename "$dir")/"
    fi

    printf '%012d\t%s%s  %s\n' "$bytes" "$indent" "$human" "$label"
  done | sort -nr | cut -f2-
}

bb_debug_new_paths_by_area() {
  local new_paths
  new_paths="$(mktemp)"
  comm -13 "$_BB_BEFORE_FILES" "$_BB_AFTER_FILES" > "$new_paths" || true

  for area in /tmp /var/tmp /opt /usr /var /etc /root; do
    echo "--- $area ---"
    grep "^${area}/" "$new_paths" | tail -n "$BB_DEBUG_NEW_PATH_LIMIT" || true
    echo
  done

  rm -f "$new_paths"
}

bb_debug_cleanup_tmp() {
  [[ "$BB_DEBUG_AUTO_CLEAN_TMP" == "1" ]] || return 0
  [[ -n "$BB_DEBUG_CLEAN_TMP_ROOTS" ]] || return 0

  echo "===== AUTO CLEANING TEMP DIRECTORIES ====="

  for tmp_root in $BB_DEBUG_CLEAN_TMP_ROOTS; do
    [[ -d "$tmp_root" ]] || continue

    echo "--- Before cleanup: $tmp_root ---"
    du -xsh "$tmp_root" 2>/dev/null || true

    find "$tmp_root" -mindepth 1 -xdev \
      -exec rm -rf -- {} + 2>/dev/null || true

    echo "--- After cleanup: $tmp_root ---"
    du -xsh "$tmp_root" 2>/dev/null || true
    echo
  done
}

bb_debug_summary_hint() {
  cat <<'EOF'
How to read this log:
- "NEW RPM PACKAGES" shows packages this script caused to be installed.
- "NEW LARGE FILES" shows large files created by this script.
- "NEW SUSPICIOUS INSTALLER/CACHE FILES" is where leftover .zip/.rpm/.tar/etc usually show up.
- "LARGE DIRECTORY TREE" shows all directories above the configured size threshold.
- If /tmp or /var/tmp grows, you probably left build artifacts behind.
- If /usr grows, the size is usually installed RPM payload, not temporary files.
- If /opt grows, it is usually vendor software or manually unpacked applications.
- Global /tmp cleanup is disabled by default because BlueBuild uses /tmp internally.
EOF
}

exec > >(tee -a "$LOG_FILE") 2>&1

if [[ "$BB_DEBUG_XTRACE" == "1" ]]; then
  export PS4='+ $(date "+%F %T") ${BASH_SOURCE##*/}:${LINENO}: '
  set -x
fi

echo "===== START ${SCRIPT_NAME} ====="
date
echo

bb_debug_summary_hint
echo

echo "===== DEBUG SETTINGS ====="
echo "BB_DEBUG_LOG_DIR=$LOG_DIR"
echo "BB_DEBUG_XTRACE=$BB_DEBUG_XTRACE"
echo "BB_DEBUG_LARGE_FILE_MB=$BB_DEBUG_LARGE_FILE_MB"
echo "BB_DEBUG_TREE_MIN_MB=$BB_DEBUG_TREE_MIN_MB"
echo "BB_DEBUG_TREE_MAX_DEPTH=$BB_DEBUG_TREE_MAX_DEPTH"
echo "BB_DEBUG_NEW_PATH_LIMIT=$BB_DEBUG_NEW_PATH_LIMIT"
echo "BB_DEBUG_TOP_RPM_LIMIT=$BB_DEBUG_TOP_RPM_LIMIT"
echo "BB_DEBUG_AUTO_CLEAN_TMP=$BB_DEBUG_AUTO_CLEAN_TMP"
echo "BB_DEBUG_CLEAN_TMP_ROOTS=$BB_DEBUG_CLEAN_TMP_ROOTS"
echo

echo "===== BEFORE TOP-LEVEL SIZES ====="
bb_debug_top_level_sizes | tee "$_BB_BEFORE_SIZES"
echo

echo "===== BEFORE TOP RPMs BY INSTALLED SIZE ====="
bb_debug_top_rpms || true
echo

bb_debug_snapshot_files > "$_BB_BEFORE_FILES"
bb_debug_rpm_names > "$_BB_BEFORE_RPM_NAMES"
bb_debug_rpm_sizes > "$_BB_BEFORE_RPM_SIZES"

bb_debug_finish() {
  local exit_code=$?

  {
    echo
    echo "===== END ${SCRIPT_NAME} (exit: ${exit_code}) ====="
    date
    echo

    if [[ -n "${BB_DEBUG_CLEANUP:-}" ]]; then
      echo "===== RUNNING BB_DEBUG_CLEANUP ====="
      eval "$BB_DEBUG_CLEANUP" || true
      echo
    fi

    bb_debug_snapshot_files > "$_BB_AFTER_FILES"
    bb_debug_rpm_names > "$_BB_AFTER_RPM_NAMES"
    bb_debug_rpm_sizes > "$_BB_AFTER_RPM_SIZES"

    echo "===== AFTER TOP-LEVEL SIZES ====="
    bb_debug_top_level_sizes | tee "$_BB_AFTER_SIZES"
    echo

    echo "===== TOP-LEVEL SIZE DIFF ====="
    diff -u "$_BB_BEFORE_SIZES" "$_BB_AFTER_SIZES" || true
    echo

    echo "===== NEW RPM PACKAGES ADDED BY THIS SCRIPT ====="
    bb_debug_new_rpms_with_sizes || true
    echo

    echo "===== CURRENT TOP RPMs BY INSTALLED SIZE ====="
    bb_debug_top_rpms || true
    echo

    echo "===== RPM SIZE LIST DIFF ====="
    diff -u "$_BB_BEFORE_RPM_SIZES" "$_BB_AFTER_RPM_SIZES" || true
    echo

    echo "===== NEW LARGE FILES CREATED BY THIS SCRIPT (> ${BB_DEBUG_LARGE_FILE_MB}MB) ====="
    bb_debug_new_large_files || true
    echo

    echo "===== ALL LARGE FILES NOW PRESENT (> ${BB_DEBUG_LARGE_FILE_MB}MB) ====="
    bb_debug_large_files || true
    echo

    echo "===== NEW SUSPICIOUS INSTALLER/CACHE FILES CREATED BY THIS SCRIPT ====="
    bb_debug_new_suspicious_files || true
    echo

    echo "===== ALL SUSPICIOUS INSTALLER/CACHE FILES NOW PRESENT ====="
    bb_debug_suspicious_files || true
    echo

    echo "===== COMMON CACHE/TEMP DIRECTORIES ====="
    bb_debug_cache_dirs || true
    echo

    echo "===== LARGE DIRECTORY TREE ====="
    bb_debug_large_directory_tree / "$BB_DEBUG_TREE_MIN_MB" "$BB_DEBUG_TREE_MAX_DEPTH" || true
    echo

    echo "===== NEW PATHS CREATED BY AREA ====="
    bb_debug_new_paths_by_area || true
    echo

    bb_debug_cleanup_tmp || true
  } || true

  rm -f \
    "$_BB_BEFORE_FILES" \
    "$_BB_AFTER_FILES" \
    "$_BB_BEFORE_SIZES" \
    "$_BB_AFTER_SIZES" \
    "$_BB_BEFORE_RPM_NAMES" \
    "$_BB_AFTER_RPM_NAMES" \
    "$_BB_BEFORE_RPM_SIZES" \
    "$_BB_AFTER_RPM_SIZES"

  return "$exit_code"
}

trap bb_debug_finish EXIT
