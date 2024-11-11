#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/gitbutler
#curl -o /tmp/gitbutler/GitButler-0.13.12-1.x86_64.rpm https://releases.gitbutler.com/releases/release/0.13.12-1449/linux/x86_64/GitButler-0.13.12-1.x86_64.rpm
cd "$(dirname "$0")"
cp gitbutler/GitButler*.rpm /tmp/gitbutler
sudo rpm-ostree install webkit2gtk4.0-devel /tmp/gitbutler/GitButler*.rpm
