#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
TS_INTEGRATION="$ROOT/files/scripts/thinstation"

WORKDIR="${WORKDIR:-$ROOT/.build/thinstation}"
TS_REPO="https://github.com/Thinstation/thinstation-ng.git"
TS_REF="$(cat "$TS_INTEGRATION/THINSTATION_REF")"

TS_SRC="$WORKDIR/thinstation-ng"
RELEASE_DIR="$ROOT/release/thinstation"

echo "Root:             $ROOT"
echo "Workdir:          $WORKDIR"
echo "ThinStation ref:  $TS_REF"

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR" "$RELEASE_DIR"

echo "Cloning ThinStation..."
git clone "$TS_REPO" "$TS_SRC"

cd "$TS_SRC"
git checkout "$TS_REF"

echo "Copying Aurora ThinStation config..."
cp "$TS_INTEGRATION/config/build.conf" \
   "$TS_SRC/ts/build/build.conf"

cp "$TS_INTEGRATION/config/thinstation.conf.buildtime" \
   "$TS_SRC/ts/build/thinstation.conf.buildtime"

if [ -f "$TS_INTEGRATION/config/thinstation.conf.network" ]; then
  cp "$TS_INTEGRATION/config/thinstation.conf.network" \
     "$TS_SRC/ts/build/thinstation.conf.network"
fi

echo "Building ThinStation..."
# ThinStation requires root for setup-chroot.
# -b means build after entering chroot.
# -o passes options to ThinStation's ./build script.
sudo ./setup-chroot -b -o --license ACCEPT

echo "Collecting PXE artifacts..."
"$TS_INTEGRATION/collect-artifacts.sh" "$TS_SRC" "$RELEASE_DIR"

echo "Done. Artifacts:"
find "$RELEASE_DIR" -maxdepth 2 -type f -ls
