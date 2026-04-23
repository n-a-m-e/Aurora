#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

cd "$(dirname "$0")"
cp systemd/hostname-reset-for-client.service /usr/lib/systemd/system/hostname-reset-for-client.service

cp systemd/kscreenlocker-fprint-login.service /usr/lib/systemd/system/kscreenlocker-fprint-login.service
cp systemd/kscreenlocker-fprint-login.sh /usr/sbin/kscreenlocker-fprint-login.sh
chmod a+x "/usr/sbin/kscreenlocker-fprint-login.sh"
