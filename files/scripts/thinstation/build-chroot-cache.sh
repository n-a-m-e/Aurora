#!/usr/bin/env bash
set -euo pipefail

ROOT="${AURORA_ROOT:-${GITHUB_WORKSPACE:-$(pwd)}}"
ROOT="$(cd "$ROOT" && pwd)"

TS_INTEGRATION="$ROOT/files/scripts/thinstation"
TS_REF="$(cat "$TS_INTEGRATION/THINSTATION_REF")"

TS_REPO="https://github.com/Thinstation/thinstation-ng.git"
WORKDIR="${WORKDIR:-$ROOT/.build/thinstation}"
TS_SRC="$WORKDIR/thinstation-ng"

OUTDIR="$ROOT/release/thinstation-chroot"
OUTFILE="$OUTDIR/thinstation-chroot.tar.zst"

rm -rf "$OUTDIR"
mkdir -p "$WORKDIR" "$OUTDIR"

echo "ThinStation ref: $TS_REF"

if [ ! -d "$TS_SRC/.git" ]; then
  echo "Cloning ThinStation..."
  git clone "$TS_REPO" "$TS_SRC"
fi

cd "$TS_SRC"

echo "Checking out ThinStation ref..."
git fetch --all --tags --prune
git checkout "$TS_REF"
git reset --hard "$TS_REF"

echo "Preparing ThinStation chroot..."
sudo ./setup-chroot -i

echo "Packaging prepared ThinStation source + chroot..."
tar \
  --numeric-owner \
  --xattrs \
  --acls \
  -C "$WORKDIR" \
  -I 'zstd -T0 -19' \
  -cpf "$OUTFILE" \
  thinstation-ng

echo "$TS_REF" > "$OUTDIR/THINSTATION_REF"

(
  cd "$OUTDIR"
  sha256sum thinstation-chroot.tar.zst THINSTATION_REF > thinstation-chroot.sha256
)

echo "Created chroot cache:"
find "$OUTDIR" -type f -ls
