#!/usr/bin/env bash
set -euo pipefail

USER_NAME="thinclient"
HOME_DIR="/var/home/thinclient"
TMP_DIR="$(mktemp -d)"

trap 'rm -rf "$TMP_DIR"' EXIT

if ! id "$USER_NAME" >/dev/null 2>&1; then
  echo "User $USER_NAME does not exist"
  exit 1
fi

# Save files we want to keep.
[ -f "$HOME_DIR/.ssh/known_hosts" ] &&
  cp "$HOME_DIR/.ssh/known_hosts" "$TMP_DIR/known_hosts"

[ -f "$HOME_DIR/.thinlinc/tlclient.conf" ] &&
  cp "$HOME_DIR/.thinlinc/tlclient.conf" "$TMP_DIR/tlclient.conf"

# Reset home.
rm -rf "$HOME_DIR"

install -d -m 0750 -o "$USER_NAME" -g "$USER_NAME" "$HOME_DIR"
install -d -m 0700 -o "$USER_NAME" -g "$USER_NAME" "$HOME_DIR/.ssh"
install -d -m 0700 -o "$USER_NAME" -g "$USER_NAME" "$HOME_DIR/.thinlinc"
install -d -m 0700 -o "$USER_NAME" -g "$USER_NAME" "$HOME_DIR/.config"
install -d -m 0700 -o "$USER_NAME" -g "$USER_NAME" "$HOME_DIR/.cache"

# Restore saved files.
[ -f "$TMP_DIR/known_hosts" ] &&
  install -m 0644 -o "$USER_NAME" -g "$USER_NAME" \
    "$TMP_DIR/known_hosts" "$HOME_DIR/.ssh/known_hosts"

[ -f "$TMP_DIR/tlclient.conf" ] &&
  install -m 0644 -o "$USER_NAME" -g "$USER_NAME" \
    "$TMP_DIR/tlclient.conf" "$HOME_DIR/.thinlinc/tlclient.conf"
