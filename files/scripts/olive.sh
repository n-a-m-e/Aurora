#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /usr/lib/opt/olive
wget -O /usr/lib/opt/olive/Olive-1e3cf53-x86_64.AppImage https://github.com/n-a-m-e/Aurora-Files/releases/download/Olive-1e3cf53-x86_64/Olive-1e3cf53-x86_64.AppImage
wget -O /usr/lib/opt/olive/Olive-8ac191ce-Linux-x86_64.AppImage https://github.com/n-a-m-e/Aurora-Files/releases/download/Olive-8ac191ce-Linux-x86_64/Olive-8ac191ce-Linux-x86_64.AppImage
chmod a+x "/usr/lib/opt/olive/Olive-1e3cf53-x86_64.AppImage"
chmod a+x "/usr/lib/opt/olive/Olive-8ac191ce-Linux-x86_64.AppImage"

wget -O /usr/Olive-1e3cf53-x86_64-share.zip https://github.com/n-a-m-e/Aurora-Files/releases/download/Olive-Share-x86_64/Olive-Share-x86_64.zip
cd /usr
unzip Olive-1e3cf53-x86_64-share.zip
rm -f /usr/Olive-1e3cf53-x86_64-share.zip
update-mime-database /usr/share/mime

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/olive.conf
d /var/opt/olive 755 root root -
L+ /var/opt/olive/Olive-1e3cf53-x86_64.AppImage - - - - /usr/lib/opt/olive/Olive-1e3cf53-x86_64.AppImage
L+ /var/opt/olive/Olive-8ac191ce-Linux-x86_64.AppImage - - - - /usr/lib/opt/olive/Olive-8ac191ce-Linux-x86_64.AppImage
EOF
