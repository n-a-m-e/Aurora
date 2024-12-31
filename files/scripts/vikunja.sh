#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/vikunja
#wget -O /tmp/vikunja/vikunja-0.24.6-x86_64.rpm https://dl.vikunja.io/vikunja/0.24.6/vikunja-0.24.6-x86_64.rpm
wget -O /tmp/vikunja/vikunja-0.24.6-x86_64.rpm https://github.com/n-a-m-e/Aurora-Files/releases/download/vikunja-0.24.6-x86_64/vikunja-0.24.6-x86_64.rpm
cd /tmp/vikunja
sudo rpm-ostree install /tmp/vikunja/vikunja*.rpm

#configure options in /etc/vikunja/config.yml
sed -i 's|timezone:.*|timezone: Australia/Sydney|g' /etc/vikunja/config.yml
sed -i 's|week_start: 0|week_start: 1|g' /etc/vikunja/config.yml
sed -i 's|language: <unset>|language: en|g' /etc/vikunja/config.yml
sed -i 's|path: "./vikunja.db"|path: "/var/opt/vikunja/vikunja.db"|g' /etc/vikunja/config.yml
sed -i 's|basepath: ./files|basepath: /var/opt/vikunja/files|g' /etc/vikunja/config.yml
sed -i 's|path: /opt/vikunja/logs|path: /var/opt/vikunja/logs|g' /etc/vikunja/config.yml
sed -i ':a;N;$!ba;s|cors:.*origins:|cors:\n  enable: true\n  origins:|g' /etc/vikunja/config.yml

#/opt does not persist after build so move to /usr/lib/opt
mv /opt/vikunja /usr/lib/opt/vikunja

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/vikunja.conf
d /var/opt/vikunja 755 root root -
d /var/opt/vikunja/files 755 root root -
d /var/opt/vikunja/logs 755 root root -
L+ /var/opt/vikunja/vikunja - - - - /usr/lib/opt/vikunja/vikunja
L+ /usr/bin/vikunja - - - - /var/opt/vikunja/vikunja
EOF
