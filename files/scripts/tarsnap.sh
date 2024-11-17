#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#mkdir /tmp/tarsnap
#wget -O /tmp/tarsnap/tarsnap-autoconf-1.0.40.tgz https://www.tarsnap.com/download/tarsnap-autoconf-1.0.40.tgz
#cd /tmp/tarsnap
#7z x -so tarsnap*.tgz | 7z x -si -ttar
#rm tarsnap*.tgz
#cd tarsnap*
#rpm-ostree install gcc make glibc-devel openssl-devel zlib-devel e2fsprogs-devel
#./configure
#make all
#make install

rpm-ostree install \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
rpm-ostree install rpmfusion-free-release rpmfusion-nonfree-release \
	--uninstall rpmfusion-free-release \
	--uninstall rpmfusion-nonfree-release
rpm-ostree install tarsnap
