#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

sed -i 's|SocketGroup=docker|SocketGroup=users|' /usr/lib/systemd/system/docker.socket

cd "$(dirname "$0")"
cp systemd/vikunja-start.service /usr/lib/systemd/system/vikunja-start.service
cp systemd/http-server.service /usr/lib/systemd/system/http-server.service
cp systemd/flatpak-force-x11.service /usr/lib/systemd/system/flatpak-force-x11.service
cp systemd/restic-backup.service /usr/lib/systemd/system/restic-backup.service
cp systemd/restic-backup.timer /usr/lib/systemd/system/restic-backup.timer


cp systemd/pihole.service /usr/lib/systemd/system/pihole.service
cp systemd/pihole.sh /usr/sbin/pihole.sh
chmod a+x "/usr/sbin/pihole.sh"

cp systemd/node-server.service /usr/lib/systemd/system/node-server.service
cp systemd/node-server.sh /usr/sbin/node-server.sh
chmod a+x "/usr/sbin/node-server.sh"

cp systemd/shared-folder.service /usr/lib/systemd/system/shared-folder.service
cp systemd/shared-folder.sh /usr/sbin/shared-folder.sh
chmod a+x "/usr/sbin/shared-folder.sh"

cp systemd/flatpak-native-messaging-hosts.service /usr/lib/systemd/system/flatpak-native-messaging-hosts.service
cp systemd/flatpak-native-messaging-hosts.sh /usr/sbin/flatpak-native-messaging-hosts.sh
chmod a+x "/usr/sbin/flatpak-native-messaging-hosts.sh"
