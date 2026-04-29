#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

sed -i 's|SocketGroup=docker|SocketGroup=users|' /usr/lib/systemd/system/docker.socket

cd "$(dirname "$0")"
#cp systemd/thinlinc-remove-symlink.service /usr/lib/systemd/system/thinlinc-remove-symlink.service
cp systemd/flatpak-force-x11.service /usr/lib/systemd/system/flatpak-force-x11.service

cp systemd/remote-shutdown.service /usr/lib/systemd/system/remote-shutdown.service
cp systemd/remote-shutdown.py /usr/sbin/remote-shutdown.py
chmod a+x "/usr/sbin/remote-shutdown.py"

cp systemd/manage-kargs.service /usr/lib/systemd/system/manage-kargs.service
cp systemd/manage-kargs.sh /usr/sbin/manage-kargs.sh
chmod a+x "/usr/sbin/manage-kargs.sh"

cp systemd/install-davinci-resolve.service /usr/lib/systemd/system/install-davinci-resolve.service
cp systemd/install-davinci-resolve.sh /usr/sbin/install-davinci-resolve.sh
chmod a+x "/usr/sbin/install-davinci-resolve.sh"

cp systemd/node-server.service /usr/lib/systemd/system/node-server.service
cp systemd/node-server.sh /usr/sbin/node-server.sh
chmod a+x "/usr/sbin/node-server.sh"

cp systemd/shared-folder.service /usr/lib/systemd/system/shared-folder.service
cp systemd/shared-folder.timer /usr/lib/systemd/system/shared-folder.timer
cp systemd/shared-folder.sh /usr/sbin/shared-folder.sh
chmod a+x "/usr/sbin/shared-folder.sh"

cp systemd/flatpak-native-messaging-hosts.service /usr/lib/systemd/system/flatpak-native-messaging-hosts.service
cp systemd/flatpak-native-messaging-hosts.sh /usr/sbin/flatpak-native-messaging-hosts.sh
chmod a+x "/usr/sbin/flatpak-native-messaging-hosts.sh"
