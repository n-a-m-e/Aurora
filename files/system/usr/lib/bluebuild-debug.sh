#!/usr/bin/env bash
set -Eeuo pipefail

# Avoid double-loading
[[ "${BLUEBUILD_DEBUG_LOADED:-}" == "1" ]] && return 0
export BLUEBUILD_DEBUG_LOADED=1

SCRIPT_NAME="$(basename "${BASH_SOURCE[1]}" .sh)"
LOG_DIR="/var/log/bluebuild-debug"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}.log"

mkdir -p "$LOG_DIR"

_BB_BEFORE_FILES="$(mktemp)"
_BB_AFTER_FILES="$(mktemp)"
_BB_BEFORE_SIZES="$(mktemp)"
_BB_AFTER_SIZES="$(mktemp)"

bb_debug_snapshot_files() {
  find /tmp /var/tmp /opt /usr/local /var \
    -xdev \
    \( -type f -o -type d -o -type l \) \
    2>/dev/null | sort
}

bb_debug_snapshot_sizes() {
  du -xhd1 /tmp /var/tmp /opt /usr/local /var 2>/dev/null | sort -h
}

# Send all script output to both console and log
exec > >(tee -a "$LOG_FILE") 2>&1

# Optional command tracing
if [[ "${BB_DEBUG_XTRACE:-1}" == "1" ]]; then
  export PS4='+ $(date "+%F %T") ${BASH_SOURCE##*/}:${LINENO}: '
  set -x
fi

echo "===== START ${SCRIPT_NAME} ====="
date
echo

echo "===== BEFORE SIZES ====="
bb_debug_snapshot_sizes | tee "$_BB_BEFORE_SIZES"
echo

echo "===== BEFORE FILE SNAPSHOT ====="
bb_debug_snapshot_files > "$_BB_BEFORE_FILES"

bb_debug_finish() {
  local exit_code=$?

  {
    echo
    echo "===== END ${SCRIPT_NAME} (exit: ${exit_code}) ====="
    date
    echo

    echo "===== AFTER SIZES ====="
    bb_debug_snapshot_sizes | tee "$_BB_AFTER_SIZES"
    echo

    echo "===== SIZE DIFF ====="
    diff -u "$_BB_BEFORE_SIZES" "$_BB_AFTER_SIZES" || true
    echo

    echo "===== AFTER FILE SNAPSHOT ====="
    bb_debug_snapshot_files > "$_BB_AFTER_FILES"

    echo
    echo "===== NEW PATHS CREATED ====="
    comm -13 "$_BB_BEFORE_FILES" "$_BB_AFTER_FILES" | tail -500 || true
    echo

    echo "===== LARGE FILES (>50MB) ====="
    find /tmp /var/tmp /opt /usr/local /var \
      -xdev -type f -size +50M \
      -printf '%s %p\n' 2>/dev/null | sort -n || true
    echo

    echo "===== LARGE DIRECTORIES ====="
    du -xhd2 /tmp /var/tmp /opt /usr/local /var 2>/dev/null | sort -h | tail -100 || true
  } || true

  rm -f \
    "$_BB_BEFORE_FILES" \
    "$_BB_AFTER_FILES" \
    "$_BB_BEFORE_SIZES" \
    "$_BB_AFTER_SIZES"

  return "$exit_code"
}

trap bb_debug_finish EXIT
