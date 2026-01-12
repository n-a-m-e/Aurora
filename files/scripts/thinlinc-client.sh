#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/thinlinc
#wget -O /tmp/thinlinc/thinlinc-client-4.18.0-3768.x86_64.rpm https://www.cendio.com/downloads/clients/thinlinc-client-4.18.0-3768.x86_64.rpm
wget -O /tmp/thinlinc/thinlinc-client-4.18.0-3768.x86_64.rpm https://github.com/n-a-m-e/Aurora-Files/releases/download/thinlinc-client-4.18.0-3768/thinlinc-client-4.18.0-3768.x86_64.rpm
cd /tmp/thinlinc
rpm-ostree install /tmp/thinlinc/thinlinc-client*.rpm

#Add client defaults
sed -i 's|FULL_SCREEN_MODE=.*|FULL_SCREEN_MODE=1|g' /opt/thinlinc/etc/tlclient.conf
sed -i 's|SERVER_NAME=.*|SERVER_NAME=aurora|g' /opt/thinlinc/etc/tlclient.conf

#/opt does not persist after build so move to /usr/lib/opt
#mv /opt/thinlinc /usr/lib/opt/thinlinc

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/thinlinc-client.conf
d /var/opt/thinlinc 755 root root -
L+ /var/opt/thinlinc/lib - - - - /usr/lib/opt/thinlinc/lib
L+ /var/opt/thinlinc/etc - - - - /usr/lib/opt/thinlinc/etc
L+ /var/opt/thinlinc/bin - - - - /usr/lib/opt/thinlinc/bin
EOF

mkdir -p /usr/etc/xdg/autostart
cp /usr/share/applications/thinlinc-client.desktop /usr/etc/xdg/autostart/thinlinc-client.desktop

#add localhost to /usr/etc/hosts
mkdir -p /usr/etc
cat <<'EOF' >> /usr/etc/hosts

# Loopback entries; do not change.
# For historical reasons, localhost precedes localhost.localdomain:
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Disable wpad
127.0.0.1   wpad wpad.*

EOF

#Block things via hosts file
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts >> /usr/etc/hosts
