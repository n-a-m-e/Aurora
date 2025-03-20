#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#Transient root needs to be enabled to mount /nix with composefs enabled
cat <<'EOF' >> /usr/lib/ostree/prepare-root.conf
[root]
transient = true
EOF

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/nix-opengl-driver.conf
L+ /run/opengl-driver - - - - /home/nix/opengl-driver
EOF

cp systemd/install-nix-software.service /usr/lib/systemd/system/install-nix-software.service
cp systemd/install-nix-software.sh /usr/sbin/install-nix-software.sh
chmod a+x "/usr/sbin/install-nix-software.sh"
