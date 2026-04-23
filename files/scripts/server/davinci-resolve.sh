#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

rpm-ostree install apr apr-util libxcrypt-compat mesa-libGLU rocminfo rocm-opencl rocm-clinfo rocm-hip unzip

cat <<'EOF' > /usr/lib/tmpfiles.d/davinci-resolve.conf
d /var/opt/resolve 0755 root root -
d /var/opt/resolve-installer 0755 root root -
EOF
