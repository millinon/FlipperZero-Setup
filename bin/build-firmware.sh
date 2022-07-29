#!/bin/sh

set -eu

FIRMWARE_DIR="$(cd `dirname $0` && pwd)/../firmware"

cd "$FIRMWARE_DIR"

if [ -z ${FW_TAG}+x ]; then
    FW_TAG="$(git describe --tags)"
fi

git checkout "$FW_TAG"
git submodule update --recursive

rsync -r static-firmware/ firmware/

FBT_NO_SYNC=y ./fbt

echo "Firmware should be in $(realpath "FIRMWARE_DIR")/dist/"
echo "Use qFlipper (https://flipperzero.one/update) to flash the DFU"
