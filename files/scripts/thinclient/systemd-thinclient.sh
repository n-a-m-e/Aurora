#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$0")"
cp thinclient-session.sh /usr/sbin/thinclient-session.sh
chmod a+x "/usr/sbin/thinclient-session.sh"

cp systemd/thinclient-reset-home.service /usr/lib/systemd/system/thinclient-reset-home.service
cp systemd/thinclient-reset-home.sh /usr/sbin/thinclient-reset-home.sh
chmod a+x "/usr/sbin/thinclient-reset-home.sh"

cp systemd/thinclient-firstboot-admin.service /usr/lib/systemd/system/thinclient-firstboot-admin.service
cp systemd/thinclient-firstboot-admin.sh /usr/sbin/thinclient-firstboot-admin.sh
chmod a+x "/usr/sbin/thinclient-firstboot-admin.sh"
