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

#/opt does not persist after build so move to /usr/lib/opt
mv /opt/vikunja /usr/lib/opt/vikunja

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/vikunja.conf
d /var/opt/vikunja 755 root root -
L+ /var/opt/vikunja/vikunja - - - - /usr/lib/opt/vikunja/vikunja
L+ /usr/bin/vikunja - - - - /var/opt/vikunja/vikunja
EOF
