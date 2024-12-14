#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/thinlinc
#wget -O /tmp/thinlinc/thinlinc-client-4.17.0-3543.x86_64.rpm https://www.cendio.com/downloads/clients/thinlinc-client-4.17.0-3543.x86_64.rpm
wget -O /tmp/thinlinc/thinlinc-client-4.17.0-3543.x86_64.rpm https://github.com/n-a-m-e/Aurora-Files/releases/download/thinlinc-client-4.17.0-3543/thinlinc-client-4.17.0-3543.x86_64.rpm
cd /tmp/thinlinc
sudo rpm-ostree install /tmp/thinlinc/thinlinc-client*.rpm

#/opt does not persist after build so move to /usr/lib/opt
mv /opt/thinlinc /usr/lib/opt/thinlinc

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/thinlinc-client.conf
d /var/opt/thinlinc 755 root root -
L+ /var/opt/thinlinc/lib - - - - /usr/lib/opt/thinlinc/lib
L+ /var/opt/thinlinc/etc - - - - /usr/lib/opt/thinlinc/etc
L+ /var/opt/thinlinc/bin - - - - /usr/lib/opt/thinlinc/bin
EOF

mkdir -p /usr/etc/xdg/autostart
cp /usr/share/applications/thinlinc-client.desktop /usr/etc/xdg/autostart/thinlinc-client.desktop
