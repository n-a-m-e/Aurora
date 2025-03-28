#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#/run/host/var/home/Shared/DaVinci_Resolve_19.1.4_Linux/squashfs-root/installer: error while loading shared libraries: libQt5Widgets.so.5: cannot open shared object file: No such file or directory
#Patching resolve binaries...
#find: ‘/opt/resolve/bin’: No such file or directory
#Applying workaround for companion programs...
#mv: cannot stat '/opt/resolve/BlackmagicRAWPlayer/BlackmagicRawAPI/libDecoderOpenCL.so': No such file or directory
#mv: cannot stat '/opt/resolve/BlackmagicRAWSpeedTest/BlackmagicRawAPI/libDecoderOpenCL.so': No such file or directory
#Add DaVinci Resolve launcher? Y/n
#y
#Adding launcher for Distrobox...
#Copying graphics...
#cp: cannot stat '/opt/resolve/graphics/DV_*': No such file or directory
#cp: cannot stat '/opt/resolve/graphics/application-x-braw-clip_256x256_mimetypes.png': No such file or directory
#cp: cannot stat '/opt/resolve/graphics/application-x-braw-clip_48x48_mimetypes.png': No such file or directory
#cp: cannot stat '/opt/resolve/graphics/application-x-braw-sidecar_256x256_mimetypes.png': No such file or directory
#cp: cannot stat '/opt/resolve/graphics/application-x-braw-sidecar_48x48_mimetypes.png': No such file or directory
#cp: cannot stat '/opt/resolve/graphics/blackmagicraw-player_256x256_apps.png': No such file or directory
#cp: cannot stat '/opt/resolve/graphics/blackmagicraw-player_48x48_apps.png': No such file or directory
#cp: cannot stat '/opt/resolve/graphics/blackmagicraw-speedtest_256x256_apps.png': No such file or directory
#cp: cannot stat '/opt/resolve/graphics/blackmagicraw-speedtest_48x48_apps.png': No such file or directory
#Setting up launchers...
#cp: cannot stat '/opt/resolve/share/*.desktop': No such file or directory
#rm: cannot remove '/root/.local/share/applications/DaVinciResolveInstaller.desktop': No such file or directory
#sed: can't read /root/.local/share/applications/blackmagicraw*.desktop: No such file or directory
#sed: can't read /root/.local/share/applications/DaVinci*.desktop: No such file or directory
#sed: can't read /root/.local/share/applications/DaVinci*.desktop: No such file or directory
#sed: can't read /root/.local/share/applications/blackmagicraw*.desktop: No such file or directory
#sed: can't read /root/.local/share/applications/DaVinci*.desktop: No such file or directory
#sed: can't read /root/.local/share/applications/blackmagicraw*.desktop: No such file or directory
#sed: can't read /root/.local/share/applications/DaVinci*.desktop: No such file or directory
#Launcher setup complete.
#You can now launch DaVinci Resolve from your application menu.

#If you want to remove the launchers later,
#re-run this command with the remove argument,
#or delete the launchers directly from:
#/root/.local/share/applications
#bash-5.2# 


mkdir /tmp/davinci-resolve
wget -O /tmp/davinci-resolve/DaVinci_Resolve_19.1.4_Linux.run.zip https://github.com/n-a-m-e/Aurora-Files/releases/download/DaVinci_Resolve_19.1.4_Linux/DaVinci_Resolve_19.1.4_Linux.run.zip
wget -O /tmp/davinci-resolve/DaVinci_Resolve_19.1.4_Linux.run.z01 https://github.com/n-a-m-e/Aurora-Files/releases/download/DaVinci_Resolve_19.1.4_Linux/DaVinci_Resolve_19.1.4_Linux.run.z01
cd /tmp/davinci-resolve
zip -F DaVinci_Resolve_19.1.4_Linux.run.zip --out DaVinci_Resolve_19.1.4_Linux.zip
unzip DaVinci_Resolve_19.1.4_Linux.zip
echo unziped
distrobox create -i ghcr.io/zelikos/davincibox-opencl:latest -n davincibox
echo created
./DaVinci_Resolve_19.1.4_Linux.run --appimage-extract
echo extracted
#distrobox enter davincibox -- setup-davinci squashfs-root/AppRun distrobox
#echo entered


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
