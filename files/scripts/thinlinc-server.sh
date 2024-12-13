#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/thinlinc
#wget -O /tmp/thinlinc/tl-4.17.0-server.zip https://www.cendio.com/downloads/server/tl-4.17.0-server.zip
wget -O /tmp/thinlinc/tl-4.17.0-server.zip https://github.com/n-a-m-e/Aurora-Files/releases/download/tl-4.17.0-server/tl-4.17.0-server.zip
#wget -O /tmp/thinlinc-client/thinlinc-client-4.17.0-3543.x86_64.rpm https://www.cendio.com/downloads/clients/thinlinc-client-4.17.0-3543.x86_64.rpm
wget -O /tmp/thinlinc/thinlinc-client-4.17.0-3543.x86_64.rpm https://github.com/n-a-m-e/Aurora-Files/releases/download/thinlinc-client-4.17.0-3543/thinlinc-client-4.17.0-3543.x86_64.rpm
cd /tmp/thinlinc
unzip tl-*server.zip
rpm-ostree install plasma-workspace-x11 sendmail /tmp/thinlinc/tl-*-server/packages/thinlinc-server-*.rpm /tmp/thinlinc/thinlinc-client*.rpm

#Don't know how to build selinux module so disable it
#sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

#/opt does not persist after build so move to /usr/lib/opt
mv /opt/thinlinc /usr/lib/opt/thinlinc

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/thinlinc.conf
d /var/lib/vsm 755 root root -
d /var/opt/thinlinc 755 root root -
d /var/opt/thinlinc/sessions 755 root root -
d /var/opt/thinlinc/utils 755 root root -
d /var/opt/thinlinc/utils/tl-printer 755 root root -
d /var/opt/thinlinc/utils/tl-ldap-certalias 755 root root -
d /var/opt/thinlinc/statistics 755 root root -
L+ /var/opt/thinlinc/desktops - - - - /usr/lib/opt/thinlinc/desktops
L+ /var/opt/thinlinc/modules - - - - /usr/lib/opt/thinlinc/modules
L+ /var/opt/thinlinc/lib - - - - /usr/lib/opt/thinlinc/lib
L+ /var/opt/thinlinc/lib64 - - - - /usr/lib/opt/thinlinc/lib64
L+ /var/opt/thinlinc/sbin - - - - /usr/lib/opt/thinlinc/sbin
L+ /var/opt/thinlinc/share - - - - /usr/lib/opt/thinlinc/share
L+ /var/opt/thinlinc/etc - - - - /usr/lib/opt/thinlinc/etc
L+ /var/opt/thinlinc/bin - - - - /usr/lib/opt/thinlinc/bin
L+ /var/opt/thinlinc/libexec - - - - /usr/lib/opt/thinlinc/libexec
EOF
