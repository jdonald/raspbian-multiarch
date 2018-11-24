#!/bin/bash -e

if [ "$(uname -m)" == "aarch64" ]; then
    echo "64-bit kernel detected, good to go"
    exit 0
fi
if ! uname -m | grep -q "armv7"; then
    >&2 echo "Unrecognized architecture: $(uname -m)"
    exit -1
fi

echo "32-bit kernel detected, setting up qemu-user for (simple) aarch64 programs"
sudo apt install -y qemu-user ${PROTECTED_PACKAGES}

if ! update-binfmts --display | grep -q "qemu-aarch64"; then
   sudo cp -vf qemu-aarch64 /var/lib/binfmts/
   sudo update-binfmts --enable qemu-aarch64
fi
echo "binfmt_misc updated for qemu-aarch64. If later you install a 64-bit kernel, run"
echo "    sudo update-binfmts --disable qemu-aarch64"
