#!/usr/bin/env bash
set -euo pipefail

ROOT="${AURORA_ROOT:-${GITHUB_WORKSPACE:-$(pwd)}}"
ROOT="$(cd "$ROOT" && pwd)"

TS_DIR="$ROOT/files/scripts/thinstation"

REPO="https://github.com/Thinstation/thinstation-ng.git"
TRACKING_BRANCH="$(cat "$TS_DIR/THINSTATION_TRACKING_BRANCH")"
CURRENT_REF="$(cat "$TS_DIR/THINSTATION_REF")"

LATEST_REF="$(
  git ls-remote "$REPO" "refs/heads/$TRACKING_BRANCH" | awk '{print $1}'
)"

echo "Tracking branch:      $TRACKING_BRANCH"
echo "Current pinned ref:   $CURRENT_REF"
echo "Latest upstream ref:  $LATEST_REF"

if [ -z "$LATEST_REF" ]; then
  echo "Could not determine latest upstream ref."
  exit 1
fi

if [ "$CURRENT_REF" = "$LATEST_REF" ]; then
  echo "ThinStation is up to date."
  exit 0
fi

echo "ThinStation update available."
echo "$LATEST_REF" > "$TS_DIR/THINSTATION_REF.latest"

echo
echo "To test the new ref:"
echo "  cp $TS_DIR/THINSTATION_REF.latest $TS_DIR/THINSTATION_REF"
echo "  files/scripts/thinstation/build-thinstation.sh"
