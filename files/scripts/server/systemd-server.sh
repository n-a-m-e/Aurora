#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

sed -i 's|SocketGroup=docker|SocketGroup=users|' /usr/lib/systemd/system/docker.socket

cd "$(dirname "$0")"

cp systemd/manage-kargs.service /usr/lib/systemd/system/manage-kargs.service
cp systemd/manage-kargs.sh /usr/sbin/manage-kargs.sh
chmod a+x "/usr/sbin/manage-kargs.sh"

cp systemd/install-davinci-resolve.service /usr/lib/systemd/system/install-davinci-resolve.service
cp systemd/install-davinci-resolve.sh /usr/sbin/install-davinci-resolve.sh
chmod a+x "/usr/sbin/install-davinci-resolve.sh"

cp systemd/node-server.service /usr/lib/systemd/system/node-server.service
cp systemd/node-server.sh /usr/sbin/node-server.sh
chmod a+x "/usr/sbin/node-server.sh"
