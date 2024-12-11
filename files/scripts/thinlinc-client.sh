#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/thinlinc-client
#wget -O /tmp/thinlinc-client/thinlinc-client-4.17.0-3543.x86_64.rpm https://www.cendio.com/downloads/clients/thinlinc-client-4.17.0-3543.x86_64.rpm
wget -O /tmp/thinlinc-client/thinlinc-client-4.17.0-3543.x86_64.rpm https://github.com/n-a-m-e/Aurora-Files/releases/download/thinlinc-client-4.17.0-3543/thinlinc-client-4.17.0-3543.x86_64.rpm
cd /tmp/thinlinc-client
sudo rpm-ostree install /tmp/thinlinc-client/thinlinc-client*.rpm
