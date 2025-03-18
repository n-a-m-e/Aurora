#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/nix
#wget -O /tmp/nix/nix-installer-x86_64-linux https://install.determinate.systems/nix/nix-installer-x86_64-linux
wget -O /tmp/nix/nix-installer-x86_64-linux https://github.com/n-a-m-e/Aurora-Files/releases/download/nix-installer-x86_64-linux/nix-installer-x86_64-linux
chmod a+x "/tmp/nix/nix-installer-x86_64-linux"
cd /tmp/nix
./nix-installer-x86_64-linux install --determinate --verbose -- --no-start-daemon

nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update

#auto.nixGLDefault: Tries to auto-detect and install Nvidia, if not, fallback to mesa. Recommended. Invoke with nixGL program.
#auto.nixGLNvidia: Proprietary Nvidia driver (auto detection of version)
#auto.nixGLNvidiaBumblebee: Proprietary Nvidia driver on hybrid hardware (auto detection).
#nixGLIntel: Mesa OpenGL implementation (intel, amd, nouveau, ...).
#auto.nixVulkanNvidia: Proprietary Nvidia driver (auto detection).
#nixVulkanIntel: Mesa Vulkan implementation.

nix-env -iA nixgl.nixGLIntel   # or replace `nixGLDefault` with your desired wrapper
nix-env -iA nixos.davinci-resolvenix-env -iA nixos.davinci-resolve
