#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

sed -i 's|SocketGroup=docker|SocketGroup=users|' /usr/lib/systemd/system/docker.socket

cd "$(dirname "$0")"
cp systemd/http-server.service /usr/lib/systemd/system/http-server.service

cp systemd/shared-folder.service /usr/lib/systemd/system/shared-folder.service
cp systemd/shared-folder.sh /usr/sbin/shared-folder.sh
chmod a+x "/usr/sbin/shared-folder.sh"

cp systemd/flatpak-native-messaging-hosts.service /usr/lib/systemd/system/flatpak-native-messaging-hosts.service
cp systemd/flatpak-native-messaging-hosts.sh /usr/sbin/flatpak-native-messaging-hosts.sh
chmod a+x "/usr/sbin/flatpak-native-messaging-hosts.sh"
