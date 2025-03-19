#!/bin/bash

if command -v nix >&2; then
  echo nix is available
else
  echo nix is not available
  while ! ping -c1 install.determinate.systems; do sleep 2; done
  mkdir /tmp/nix
  wget -O /tmp/nix/nix-installer-x86_64-linux https://install.determinate.systems/nix/nix-installer-x86_64-linux
  chmod a+x "/tmp/nix/nix-installer-x86_64-linux"
  cd /tmp/nix
  ./nix-installer-x86_64-linux install ostree --determinate --no-confirm
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

#auto.nixGLDefault: Tries to auto-detect and install Nvidia, if not, fallback to mesa. Recommended. Invoke with nixGL program.
#auto.nixGLNvidia: Proprietary Nvidia driver (auto detection of version)
#auto.nixGLNvidiaBumblebee: Proprietary Nvidia driver on hybrid hardware (auto detection).
#nixGLIntel: Mesa OpenGL implementation (intel, amd, nouveau, ...).
#auto.nixVulkanNvidia: Proprietary Nvidia driver (auto detection).
#nixVulkanIntel: Mesa Vulkan implementation.
if command -v nixGLIntel >&2; then
  echo nixGLIntel is available
else
  echo nixGLIntel is not available
  while ! ping -c1 github.com; do sleep 2; done
  nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
  #nix-env -iA nixgl.nixGLIntel or replace `nixGLDefault` with your desired wrapper
  nix-env -iA nixgl.nixGLIntel
fi

if command -v davinci-resolve >&2; then
  echo davinci-resolve is available
else
  echo davinci-resolve is not available
  while ! ping -c1 github.com; do sleep 2; done
  nix-env -iA nixos.davinci-resolvenix-env -iA nixos.davinci-resolve
fi
