#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#prepend hostname to /usr/etc/hosts
cat <<EOF > /usr/etc/hosts
# Loopback entries; do not change.
127.0.0.1   aurora
::1         aurora

$(cat /usr/etc/hosts)
EOF
