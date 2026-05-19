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
ARCHIVE_PREFIX="thinstation-chroot.tar.zst"
PART_PREFIX="$OUTDIR/$ARCHIVE_PREFIX.part-"
PART_SIZE="${CHROOT_PART_SIZE:-1900M}"

rm -rf "$OUTDIR"
mkdir -p "$WORKDIR" "$OUTDIR"

echo "ThinStation ref: $TS_REF"
echo "Output directory: $OUTDIR"
echo "Archive part size: $PART_SIZE"

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

echo "Packaging prepared ThinStation source + chroot into split archive parts..."
# GitHub Release assets have a 2 GiB per-file limit. The prepared ThinStation
# chroot is larger than that, so stream the compressed tarball directly into
# split parts instead of creating one oversized archive first.
tar \
  --numeric-owner \
  --xattrs \
  --acls \
  -C "$WORKDIR" \
  -I 'zstd -T0 -19' \
  -cpf - \
  thinstation-ng \
  | split -b "$PART_SIZE" -d -a 3 - "$PART_PREFIX"

echo "$TS_REF" > "$OUTDIR/THINSTATION_REF"

(
  cd "$OUTDIR"
  sha256sum "$ARCHIVE_PREFIX".part-* THINSTATION_REF > thinstation-chroot.sha256
)

echo "Created chroot cache parts:"
find "$OUTDIR" -type f -ls
