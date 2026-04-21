#!/usr/bin/env bash
set -Eeuo pipefail

BIN_FILE="/var/opt/resolve/bin/resolve"
INSTALLER_DIR="/var/opt/resolve-installer"
WORKDIR="/tmp/davinci-resolve"

cleanup() {
  rm -rf "$WORKDIR"
}

trap cleanup EXIT

if [[ -x "$BIN_FILE" ]]; then
  echo "DaVinci Resolve already installed"
else
  shopt -s nullglob
  ZIP_FILES=("$INSTALLER_DIR"/DaVinci_Resolve_*_Linux.zip)
  shopt -u nullglob

  if [[ ${#ZIP_FILES[@]} -eq 0 ]]; then
    echo "Could not find DaVinci Resolve zip file in $INSTALLER_DIR"
    exit 0
  fi

  ZIP_FILE="${ZIP_FILES[0]}"

  rm -rf "$WORKDIR"
  mkdir -p "$WORKDIR"

  unzip "$ZIP_FILE" -d "$WORKDIR"

  cd "$WORKDIR"

  shopt -s nullglob
  RUN_FILES=(DaVinci_Resolve_*_Linux.run)
  shopt -u nullglob

  if [[ ${#RUN_FILES[@]} -eq 0 ]]; then
    echo "Could not find DaVinci Resolve .run installer"
    exit 1
  fi

  RUN_FILE="${RUN_FILES[0]}"

  chmod +x "$RUN_FILE"
  "./$RUN_FILE" --appimage-extract

  QT_QPA_PLATFORM=minimal SKIP_PACKAGE_CHECK=1 "$WORKDIR/squashfs-root/AppRun" -i -a -y

  echo "DaVinci Resolve install complete"
fi

if [[ -f /opt/resolve/BlackmagicRAWPlayer/BlackmagicRawAPI/libDecoderOpenCL.so ]]; then
  mv -f /opt/resolve/BlackmagicRAWPlayer/BlackmagicRawAPI/libDecoderOpenCL.so /opt/resolve/BlackmagicRAWPlayer/BlackmagicRawAPI/libDecoderOpenCL.so.bak
fi

if [[ -f /opt/resolve/BlackmagicRAWSpeedTest/BlackmagicRawAPI/libDecoderOpenCL.so ]]; then
  mv -f /opt/resolve/BlackmagicRAWSpeedTest/BlackmagicRawAPI/libDecoderOpenCL.so /opt/resolve/BlackmagicRAWSpeedTest/BlackmagicRawAPI/libDecoderOpenCL.so.bak
fi

if [[ -d /opt/resolve/libs ]]; then
  cd /opt/resolve/libs
  mkdir -p disabled-libraries

  compgen -G 'libglib*' > /dev/null && mv -f libglib* disabled-libraries/ || true
  compgen -G 'libgio*' > /dev/null && mv -f libgio* disabled-libraries/ || true
  compgen -G 'libgmodule*' > /dev/null && mv -f libgmodule* disabled-libraries/ || true
fi
