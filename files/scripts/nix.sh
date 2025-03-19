#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/nix
wget -O /tmp/nix/nix-multi-user-2.24.10.rpm https://nix-community.github.io/nix-installers/nix/x86_64/nix-multi-user-2.24.10.rpm
cd /tmp/nix
rpm-ostree install /tmp/nix/nix-multi-user*.rpm

nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update

#auto.nixGLDefault: Tries to auto-detect and install Nvidia, if not, fallback to mesa. Recommended. Invoke with nixGL program.
#auto.nixGLNvidia: Proprietary Nvidia driver (auto detection of version)
#auto.nixGLNvidiaBumblebee: Proprietary Nvidia driver on hybrid hardware (auto detection).
#nixGLIntel: Mesa OpenGL implementation (intel, amd, nouveau, ...).
#auto.nixVulkanNvidia: Proprietary Nvidia driver (auto detection).
#nixVulkanIntel: Mesa Vulkan implementation.

nix-env -iA nixgl.nixGLIntel   # or replace `nixGLDefault` with your desired wrapper
nix-env -iA nixos.davinci-resolvenix-env -iA nixos.davinci-resolve

#/nix does not persist after build so move to /usr/nix
mv /nix /usr/nix

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/nix.conf
L+ /nix - - - - /usr/nix
EOF
