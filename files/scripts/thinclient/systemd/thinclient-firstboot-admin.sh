#!/usr/bin/env bash
set -euo pipefail

ADMIN_USER="admin"
ADMIN_UID="2000"
ADMIN_GID="2000"
ADMIN_HOME="/var/home/${ADMIN_USER}"

if id "${ADMIN_USER}" >/dev/null 2>&1; then
  exit 0
fi

clear || true
echo "Thin client first-boot setup"
echo
echo "No local admin account has been configured."
echo "Create a password for the local '${ADMIN_USER}' account."
echo

if ! getent group "${ADMIN_USER}" >/dev/null 2>&1; then
  groupadd --gid "${ADMIN_GID}" "${ADMIN_USER}"
fi

useradd \
  --uid "${ADMIN_UID}" \
  --gid "${ADMIN_USER}" \
  --create-home \
  --home-dir "${ADMIN_HOME}" \
  --shell /bin/bash \
  --groups wheel \
  "${ADMIN_USER}"

while true; do
  passwd "${ADMIN_USER}" && break
  echo
  echo "Password setup failed. Try again."
done

echo
echo "Local admin account created."
sleep 2
