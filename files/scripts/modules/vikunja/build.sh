#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

#configure options in /etc/vikunja/config.yml
sed -i 's|timezone:.*|timezone: Australia/Sydney|g' /etc/vikunja/config.yml
sed -i 's|week_start: 0|week_start: 1|g' /etc/vikunja/config.yml
sed -i 's|language: <unset>|language: en|g' /etc/vikunja/config.yml
sed -i 's|path: "./vikunja.db"|path: "/var/opt/vikunja/vikunja.db"|g' /etc/vikunja/config.yml
sed -i 's|basepath: ./files|basepath: /var/opt/vikunja/files|g' /etc/vikunja/config.yml
sed -i 's|path: /opt/vikunja/logs|path: /var/opt/vikunja/logs|g' /etc/vikunja/config.yml
sed -i ':a;N;$!ba;s|cors:.*origins:|cors:\n  enable: true\n  origins:|g' /etc/vikunja/config.yml
