#!/usr/bin/env bash
set -euo pipefail

ROOT="${AURORA_ROOT:-${GITHUB_WORKSPACE:-$(pwd)}}"
ROOT="$(cd "$ROOT" && pwd)"

TS_INTEGRATION="$ROOT/files/scripts/thinstation"

WORKDIR="${WORKDIR:-$ROOT/.build/thinstation}"
TS_REF="$(cat "$TS_INTEGRATION/THINSTATION_REF")"

TS_SRC="$WORKDIR/thinstation-ng"
RELEASE_DIR="$ROOT/release/thinstation"

echo "Root:             $ROOT"
echo "Workdir:          $WORKDIR"
echo "ThinStation ref:  $TS_REF"

rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

if [ ! -d "$TS_SRC/.git" ]; then
  echo "Prepared ThinStation source/chroot not found at:"
  echo "  $TS_SRC"
  echo
  echo "Build and download the chroot cache first:"
  echo "  .github/workflows/build.yml -> thinstation-chroot"
  exit 1
fi

cd "$TS_SRC"

echo "Using prepared ThinStation source/chroot:"
echo "  $TS_SRC"

echo "Copying Aurora ThinStation config..."
cp "$TS_INTEGRATION/config/build.conf"    "$TS_SRC/ts/build/build.conf"

cp "$TS_INTEGRATION/config/thinstation.conf.buildtime"    "$TS_SRC/ts/build/thinstation.conf.buildtime"

if [ -f "$TS_INTEGRATION/config/thinstation.conf.network" ]; then
  cp "$TS_INTEGRATION/config/thinstation.conf.network"      "$TS_SRC/ts/build/thinstation.conf.network"
fi

echo "Building ThinStation PXE artifacts from prepared chroot..."
sudo ./setup-chroot -e "cd /build && ./build --license ACCEPT"

echo "Collecting PXE artifacts..."
"$TS_INTEGRATION/collect-artifacts.sh" "$TS_SRC" "$RELEASE_DIR"

echo "Done. Artifacts:"
find "$RELEASE_DIR" -maxdepth 2 -type f -ls
