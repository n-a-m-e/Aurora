#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm --init none
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update

#auto.nixGLDefault: Tries to auto-detect and install Nvidia, if not, fallback to mesa. Recommended. Invoke with nixGL program.
#auto.nixGLNvidia: Proprietary Nvidia driver (auto detection of version)
#auto.nixGLNvidiaBumblebee: Proprietary Nvidia driver on hybrid hardware (auto detection).
#nixGLIntel: Mesa OpenGL implementation (intel, amd, nouveau, ...).
#auto.nixVulkanNvidia: Proprietary Nvidia driver (auto detection).
#nixVulkanIntel: Mesa Vulkan implementation.

nix-env -iA nixgl.nixGLIntel   # or replace `nixGLDefault` with your desired wrapper
nix-env -iA nixos.davinci-resolvenix-env -iA nixos.davinci-resolve
