#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

mkdir /tmp/brother-ql
BB_DEBUG_CLEANUP='rm -rf /tmp/brother-ql'

chmod a+x "/usr/bin/brother_ql_analyse"
chmod a+x "/usr/bin/brother_ql_create"
chmod a+x "/usr/bin/brother_ql_print"
chmod a+x "/usr/bin/brother_ql_debug"
chmod a+x "/usr/bin/brother_ql_info"

SITE_PACKAGES="$(python3 - <<'PY'
import sysconfig
print(sysconfig.get_paths()["purelib"])
PY
)"

curl -LfsS "https://github.com/n-a-m-e/Aurora-Files/releases/download/brother_ql-0.8.3/brother_ql-0.8.3.tar.gz" -o "/tmp/brother-ql/brother_ql.tar.gz"
tar -xzf "/tmp/brother-ql/brother_ql.tar.gz" -C "/tmp/brother-ql"

install -d "$SITE_PACKAGES"
cp -a "/tmp/brother-ql/brother_ql-0.8.3/brother_ql" "$SITE_PACKAGES/"
cp -a "/tmp/brother-ql/brother_ql-0.8.3/brother_ql.egg-info" "$SITE_PACKAGES/"

python3 - <<'PY'
import brother_ql
import packbits
from PIL import Image
import numpy
import future
PY
