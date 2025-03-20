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
# Ensure /run/opengl-driver directory exists
d /run/opengl-driver 0755 root root - -
# Mesa
L+ /run/opengl-driver/mesa - - - !/usr/lib64/dri /usr/lib64/dri
# NVIDIA
L+ /run/opengl-driver/nvidia - - - !/usr/lib64/nvidia /usr/lib64/nvidia
# NVIDIA
L+ /run/opengl-driver/nvidia-bumblebee - - - !/usr/lib64/nvidia-bumblebee /usr/lib64/nvidia-bumblebee
# AMDGPU-PRO
L+ /run/opengl-driver/amdgpu-pro - - - !/opt/amdgpu-pro/lib64 /opt/amdgpu-pro/lib64
# Intel
L+ /run/opengl-driver/intel - - - !/opt/intel /opt/intel
# NVIDIA CUDA
L+ /run/opengl-driver/cuda - - - !/usr/local/cuda /usr/local/cuda
# OpenCL Mesa
L+ /run/opengl-driver/opencl-mesa - - - !/usr/lib64/opencl-mesa /usr/lib64/opencl-mesa
# OpenCL NVIDIA
L+ /run/opengl-driver/opencl-nvidia - - - !/usr/lib64/opencl-nvidia /usr/lib64/opencl-nvidia
# AMD ROCm
L+ /run/opengl-driver/rocm - - - !/opt/rocm /opt/rocm
# Vulkan
L+ /run/opengl-driver/libvulkan_intel.so - - - !/usr/lib64/libvulkan_intel.so /usr/lib64/libvulkan_intel.so
L+ /run/opengl-driver/libvulkan_radeon.so - - - !/usr/lib64/libvulkan_radeon.so /usr/lib64/libvulkan_radeon.so
L+ /run/opengl-driver/libvulkan_nvidia.so - - - !/usr/lib64/libvulkan_nvidia.so /usr/lib64/libvulkan_nvidia.so
EOF

cp systemd/install-nix-software.service /usr/lib/systemd/system/install-nix-software.service
cp systemd/install-nix-software.sh /usr/sbin/install-nix-software.sh
chmod a+x "/usr/sbin/install-nix-software.sh"
