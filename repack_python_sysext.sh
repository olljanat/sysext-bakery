#!/usr/bin/env bash
set -euo pipefail

# Copy Python sysext content to writable temp folder
wget https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar-python.raw
OLDTMP=$(mktemp -d)
LOOPDEV=$(sudo losetup -f)
sudo losetup $LOOPDEV flatcar-python.raw
sudo mount -t squashfs $LOOPDEV $OLDTMP
NEWTMP=$(mktemp -d)
cp -rv $OLDTMP/* $NEWTMP/
sudo umount $OLDTMP
sudo losetup -d $LOOPDEV
rm flatcar-python.raw

# Remove externally managed flag to avoid issues with
# https://peps.python.org/pep-0668/ when installing modules
find $NEWTMP -name 'EXTERNALLY-MANAGED' -exec rm {} \;

mkdir python
mv $NEWTMP/* python/
rm python/usr/lib/extension-release.d/*
RELOAD=1 ./bake.sh python
rm -rf "python"
