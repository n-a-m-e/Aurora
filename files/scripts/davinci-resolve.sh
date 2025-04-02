#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#!/bin/bash

rpm-ostree install apr apr-util libxcrypt-compat libcurl libcurl-devel mesa-libGLU rocminfo rocm-opencl rocm-clinfo rocm-hip

mkdir /tmp/davinci-resolve
wget -O /tmp/davinci-resolve/DaVinci_Resolve_19.1.4_Linux.run.zip https://github.com/n-a-m-e/Aurora-Files/releases/download/DaVinci_Resolve_19.1.4_Linux/DaVinci_Resolve_19.1.4_Linux.run.zip
wget -O /tmp/davinci-resolve/DaVinci_Resolve_19.1.4_Linux.run.z01 https://github.com/n-a-m-e/Aurora-Files/releases/download/DaVinci_Resolve_19.1.4_Linux/DaVinci_Resolve_19.1.4_Linux.run.z01
cd /tmp/davinci-resolve
zip -F DaVinci_Resolve_19.1.4_Linux.run.zip --out DaVinci_Resolve_19.1.4_Linux.zip
unzip DaVinci_Resolve_19.1.4_Linux.zip
echo "Unziped Linux.run..."
./DaVinci_Resolve_19.1.4_Linux.run --appimage-extract

# See https://github.com/zelikos/davincibox/issues/35
QT_QPA_PLATFORM=minimal SKIP_PACKAGE_CHECK=1 /tmp/davinci-resolve/squashfs-root/AppRun -i -a -y

mv /opt/resolve/BlackmagicRAWPlayer/BlackmagicRawAPI/libDecoderOpenCL.so /opt/resolve/BlackmagicRAWPlayer/BlackmagicRawAPI/libDecoderOpenCL.so.bak
mv /opt/resolve/BlackmagicRAWSpeedTest/BlackmagicRawAPI/libDecoderOpenCL.so /opt/resolve/BlackmagicRAWSpeedTest/BlackmagicRawAPI/libDecoderOpenCL.so.bak

cd /opt/resolve/libs
mkdir disabled-libraries
mv libglib* disabled-libraries
mv libgio* disabled-libraries
mv libgmodule* disabled-libraries 

mv /opt/resolve /usr/lib/opt/resolve

#create required directories and symlinks at boot
cat <<'EOF' > /usr/lib/tmpfiles.d/davinci-resolve.conf
L+ /var/opt/resolve - - - - /usr/lib/opt/resolve
EOF

#You have existing.zip but want to split it into 50M sized parts.
#zip existing.zip --out new.zip -s 50m
#will create
#new.zip
#new.z01
#new.z02
#new.z03
#To extract them, you should first collect the files together and run
#zip -F new.zip --out existing.zip
#or
#zip -s0 new.zip --out existing.zip
#to recreate your existing.zip, Then you can simply
#unzip existing.zip.
