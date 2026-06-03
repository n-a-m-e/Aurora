#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

chmod a+x "/usr/bin/shared-folder.sh"
chmod a+x "/usr/bin/node-server.sh"

sed -i 's|SocketGroup=docker|SocketGroup=users|' /usr/lib/systemd/system/docker.socket

#Change Umask to make shared folders possible
sed -i 's/UMASK		022/UMASK		002/g' /etc/login.defs
sed -i 's/HOME_MODE	0700/HOME_MODE	0770/g' /etc/login.defs
sed -i 's/PASS_MIN_LEN	8/PASS_MIN_LEN	1/g' /etc/login.defs

echo "umask 002" >> /etc/profile.d/umask.sh
