#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/bluebuild-debug.sh

. /etc/os-release

curl -fsSL "https://n-a-m-e.github.io/rpm-repo-sonicde/sonicde-fedora-${VERSION_ID}.repo" -o /etc/yum.repos.d/sonicde.repo

dnf install -y --allowerasing --best task-sonicde
