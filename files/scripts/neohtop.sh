

#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir /tmp/neohtop
#wget -O /tmp/thinlinc/thinlinc-client-4.18.0-3768.x86_64.rpm https://www.cendio.com/downloads/clients/thinlinc-client-4.18.0-3768.x86_64.rpm
wget -O /tmp/neohtop/NeoHtop_1.1.2_x86_64.rpm https://github.com/Abdenasser/neohtop/releases/download/v1.1.2/NeoHtop_1.1.2_x86_64.rpm
cd /tmp/neohtop
sudo rpm-ostree install /tmp/neohtop/NeoHtop*.rpm
