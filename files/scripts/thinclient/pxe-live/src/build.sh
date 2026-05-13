#!/usr/bin/env bash
set -euo pipefail

dnf install -y \
  dracut-live \
  dracut-network \
  grub2-efi-x64-cdboot \
  xorriso \
  isomd5sum \
  squashfs-tools \
  jq

kernel="$(
  kernel-install list --json pretty |
    jq -r '.[] | select(.has_kernel == true) | .version' |
    head -n1
)"

if [ -z "$kernel" ]; then
  echo "No installed kernel found"
  exit 1
fi

DRACUT_NO_XATTR=1 dracut \
  --force \
  --verbose \
  --zstd \
  --reproducible \
  --no-hostonly \
  --add "dmsquash-live dmsquash-live-autooverlay livenet network-manager" \
  "/usr/lib/modules/${kernel}/initramfs.img" \
  "${kernel}"

mkdir -p /boot/efi
cp -av /usr/lib/efi/*/*/EFI /boot/efi/

systemctl disable bootloader-update.service || true

systemctl enable NetworkManager.service || true
systemctl enable greetd.service || true
systemctl enable thinclient-reset-home.service || true

# Diskless PXE would ask for admin setup every boot.
systemctl disable thinclient-firstboot-admin.service || true

mkdir -p /usr/lib/bootc-image-builder
cp /src/iso.yaml /usr/lib/bootc-image-builder/iso.yaml

dnf clean all
