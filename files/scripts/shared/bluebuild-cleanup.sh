#!/usr/bin/env bash
set -Eeuo pipefail

echo "===== AGGRESSIVE CLEANUP START ====="

# Clean /tmp, but preserve BlueBuild runtime dirs
find /tmp -mindepth 1 -maxdepth 1 -xdev \
  ! -name files \
  ! -name modules \
  ! -name scripts \
  ! -name nu \
  ! -name bins \
  ! -name keys \
  -exec rm -rf -- {} + 2>/dev/null || true

# Temp/cache cleanup
rm -rf /var/tmp/* 2>/dev/null || true
rm -rf /var/cache/dnf /var/lib/dnf /var/cache/yum 2>/dev/null || true
rm -rf /var/tmp/rpm-* /var/tmp/dnf-* 2>/dev/null || true

# Logs: keep files, remove contents
find /var/log -type f -exec truncate -s 0 {} \; 2>/dev/null || true
rm -f /var/log/tlsetup.log 2>/dev/null || true

# Root/user caches
rm -rf /root/.cache /root/.local /root/.npm /root/.cargo 2>/dev/null || true

# Docs/man/info
rm -rf /usr/share/doc/* 2>/dev/null || true
rm -rf /usr/share/man/* 2>/dev/null || true
rm -rf /usr/share/info/* 2>/dev/null || true

# Locales: keep English translations only
if [[ -d /usr/share/locale ]]; then
  find /usr/share/locale -mindepth 1 -maxdepth 1 \
    ! -name 'en*' \
    -exec rm -rf {} + 2>/dev/null || true
fi

# Aggressive locale archive cleanup
# This saves a lot of space, but test locale-sensitive apps after removal.
rm -f /usr/lib/locale/locale-archive 2>/dev/null || true
rm -f /usr/lib/locale/locale-archive.real 2>/dev/null || true

# Usually removable data
rm -rf /usr/share/GeoIP 2>/dev/null || true
rm -f /usr/share/homebrew.tar.zst 2>/dev/null || true

# Optional: remove large CJK serif font if you don't need CJK serif rendering
rm -f /usr/share/fonts/google-noto-serif-cjk-vf-fonts/NotoSerifCJK-VF.ttc 2>/dev/null || true

# Remove build/signing/helper tools not needed at runtime
# Keep Docker itself because this server runs/pulls containers.
rm -f /usr/bin/cosign 2>/dev/null || true
rm -f /usr/bin/rclone 2>/dev/null || true
rm -f /usr/libexec/docker/cli-plugins/docker-buildx 2>/dev/null || true

# Remove BlueBuild/nushell helper plugin if not needed after build
rm -f /usr/libexec/bluebuild/nu/nu_plugin_polars 2>/dev/null || true

# Static libraries: usually unnecessary at runtime
find /usr/lib /usr/lib64 -type f -name '*.a' -delete 2>/dev/null || true

# Python cache
find /usr -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true
find /usr -type f -name '*.pyc' -delete 2>/dev/null || true
find /usr -type f -name '*.pyo' -delete 2>/dev/null || true

# Kernel build/source trees
# Keep initramfs.img for now.
rm -rf /usr/lib/modules/*/build 2>/dev/null || true
rm -rf /usr/lib/modules/*/source 2>/dev/null || true

# Flatpak temp/cache
rm -rf /var/lib/flatpak/repo/tmp 2>/dev/null || true

# Installer/archive leftovers outside /usr.
# Important: don't globally delete /usr/**/*.xz, because firmware uses .xz files.
find /opt /var /root \
  -xdev -type f \
  \( -iname '*.zip' -o -iname '*.tar' -o -iname '*.tar.gz' -o -iname '*.tgz' \
  -o -iname '*.tar.xz' -o -iname '*.txz' -o -iname '*.rpm' -o -iname '*.deb' \
  -o -iname '*.AppImage' -o -iname '*.run' -o -iname '*.iso' -o -iname '*.7z' \
  -o -iname '*.rar' -o -iname '*.zst' \) \
  -delete 2>/dev/null || true

# Strip binaries/libs
# Keep DaVinci Resolve ROCm/OpenCL libraries, Docker runtime, KDE/Qt WebEngine, and initramfs.
if command -v strip >/dev/null 2>&1 && command -v file >/dev/null 2>&1; then
  find /usr/bin /usr/sbin /usr/lib /usr/lib64 /opt \
    -xdev -type f -exec file {} \; 2>/dev/null | \
    grep -E 'ELF.*not stripped' | cut -d: -f1 | \
    xargs -r strip --strip-unneeded 2>/dev/null || true
fi

echo "===== FINAL SIZE SUMMARY ====="
du -xhd1 /tmp /var/tmp /var /usr /opt /root 2>/dev/null | sort -h || true

echo "===== REMAINING LARGE FILES >50MB ====="
find /tmp /var/tmp /opt /usr /var /root \
  -xdev -type f -size +50M \
  -printf '%s\t%p\n' 2>/dev/null | sort -n || true

echo "===== AGGRESSIVE CLEANUP END ====="
