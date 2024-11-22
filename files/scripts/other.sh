#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#Enable Zed to work without GPU
echo "ZED_ALLOW_EMULATED_GPU=1" >> /usr/etc/environment

#Block things via hosts file
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts >> /usr/etc/hosts
#Remove Google Ads Blocking
sed -i 's/0.0.0.0 google-analytics.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 ssl.google-analytics.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 www.google-analytics.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 ads.google.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 adservice.google.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 s0-2mdn-net.l.google.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 googleadservices.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 pagead2.googleadservices.com//g' /usr/etc/hosts
sed -i 's/0.0.0.0 www.googleadservices.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 static.googleadsserving.cn//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 ade.googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 pagead.googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 pagead2.googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 tpc.googlesyndication.com//g' /usr/etc/hosts
#sed -i 's/0.0.0.0 displayads-formats.googleusercontent.com//g' /usr/etc/hosts

#Change Umask to make shared folders possible
sed -i 's/UMASK		022/UMASK		002/g' /etc/login.defs
sed -i 's/HOME_MODE	0700/HOME_MODE	0770/g' /etc/login.defs
sed -i 's/PASS_MIN_LEN	8/PASS_MIN_LEN	1/g' /etc/login.defs
