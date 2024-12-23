#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#Don't know how to build selinux module so disable it
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

#add hostname to /usr/lib/opt/thinlinc/etc/conf.d/vsmagent.hconf
sed -i 's|agent_hostname=|agent_hostname=aurora|g' /usr/lib/opt/thinlinc/etc/conf.d/vsmagent.hconf

#add localhost to /usr/etc/hosts
mkdir -p /usr/etc
cat <<'EOF' >> /usr/etc/hosts

# Loopback entries; do not change.
127.0.0.1   aurora
::1         aurora

# Loopback entries; do not change.
# For historical reasons, localhost precedes localhost.localdomain:
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Disable wpad
127.0.0.1   wpad wpad.*

EOF

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
