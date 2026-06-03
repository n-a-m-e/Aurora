#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

dnf -y copr enable lizardbyte/beta
rpm-ostree install Sunshine libcap

SUNSHINE_BIN="$(readlink -f "$(command -v sunshine)")"
if [[ -n "${SUNSHINE_BIN:-}" ]]; then
  setcap -r "$SUNSHINE_BIN" || true
fi
