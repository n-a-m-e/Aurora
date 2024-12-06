#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Preparation steps
mkdir /tmp/rpm-ostree
ostree init --repo=/var/www/html/ostree init --mode=archive

# Build Tree

rpm-ostree compose install --repo=/var/www/html/ostree ~/fedora-atomic/fedora-atomic-host.json /tmp/rpm-ostree

# Install some pip packages into the tree

pip install --ignore-installed --root /tmp/rpm-ostree/rootfs brother_ql

# Run postprocess and commit the tree

cd  /tmp/rpm-ostree/rootfs
rpm-ostree compose postprocess . ~/fedora-atomic/fedora-atomic-host.json rpm-ostree compose
rpm-ostree compose commit --repo=/var/www/html/ostree ~/fedora-atomic/fedora-atomic-host.json /tmp/rpm-ostree/rootfs
