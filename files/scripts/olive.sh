#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/olive
#wget -O /tmp/olive/Olive-1e3cf53-x86_64.AppImage https://github.com/olive-editor/olive/releases/download/0.1.0/Olive-1e3cf53-x86_64.AppImage
wget -O /tmp/olive/Olive-1e3cf53-x86_64.AppImage https://github.com/n-a-m-e/Aurora-Files/releases/download/Olive-1e3cf53-x86_64/Olive-1e3cf53-x86_64.AppImage
wget -O /tmp/olive/Olive-1e3cf53-x86_64-share.zip https://github.com/n-a-m-e/Aurora-Files/releases/download/Olive-1e3cf53-x86_64-share/Olive-1e3cf53-x86_64-share.zip
cd /tmp/olive
unzip Olive-1e3cf53-x86_64-share.zip
cp -r /tmp/olive/share /usr/share
mkdir /usr/lib/opt/olive
mv /tmp/olive/Olive-1e3cf53-x86_64.AppImage /usr/lib/opt/olive/Olive-1e3cf53-x86_64.AppImage
