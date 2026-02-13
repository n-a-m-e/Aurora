#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

cd "$(dirname "$0")"
cp systemd/hostname-reset-for-client.service /usr/lib/systemd/system/hostname-reset-for-client.service
cp systemd/kscreenlocker-fprint-login.service /usr/lib/systemd/system/kscreenlocker-fprint-login.service
