#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#Enable Zed to work without GPU
echo "ZED_ALLOW_EMULATED_GPU=1" >> /usr/etc/environment

#Change Umask to make shared folders possible
sed -i 's/UMASK		022/UMASK		002/g' /etc/login.defs
sed -i 's/HOME_MODE	0700/HOME_MODE	0770/g' /etc/login.defs
sed -i 's/PASS_MIN_LEN	8/PASS_MIN_LEN	1/g' /etc/login.defs

echo "umask 002" >> /etc/profile.d/umask.sh
