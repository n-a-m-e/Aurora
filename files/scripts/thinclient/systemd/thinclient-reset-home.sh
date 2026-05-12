#!/usr/bin/env bash
set -euo pipefail

USER_NAME="thinclient"
HOME_DIR="/var/home/thinclient"

if ! id "${USER_NAME}" >/dev/null 2>&1; then
  echo "User ${USER_NAME} does not exist"
  exit 1
fi

rm -rf "${HOME_DIR}"

install -d -m 0750 -o "${USER_NAME}" -g "${USER_NAME}" "${HOME_DIR}"
install -d -m 0700 -o "${USER_NAME}" -g "${USER_NAME}" "${HOME_DIR}/.ssh"
install -d -m 0700 -o "${USER_NAME}" -g "${USER_NAME}" "${HOME_DIR}/.thinlinc"
install -d -m 0700 -o "${USER_NAME}" -g "${USER_NAME}" "${HOME_DIR}/.config"
install -d -m 0700 -o "${USER_NAME}" -g "${USER_NAME}" "${HOME_DIR}/.cache"

if [ -f /etc/thinclient/known_hosts ]; then
  install -m 0644 -o "${USER_NAME}" -g "${USER_NAME}" \
    /etc/thinclient/known_hosts \
    "${HOME_DIR}/.ssh/known_hosts"
fi
