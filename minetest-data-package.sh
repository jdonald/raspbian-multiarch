#!/bin/bash -e

# Debian's minetest-data appears to be missing its Multi-Arch line

if [ -n "$(ls minetest-data*.deb 2> /dev/null)" ]; then
    echo "Patched minetest-data found"
    exit 0
fi

sudo apt install -y fonts-liberation python-imaging
apt-get download minetest-data
DEB="$(ls minetest-data*.deb)"
rm -rf tmp; mkdir -p tmp; cd tmp
ar xf ../"${DEB}"
mkdir newcontrol; cd newcontrol
tar xf ../control.tar.gz
echo "Multi-Arch: foreign">> control
tar czf ../control.tar.gz *
cd .. # leave newcontrol/
ar cr ../"${DEB}" debian-binary control.tar.gz data.tar.*
cd .. # leave tmp/
echo "Fixed up minetest-data to be truly multiarch"
