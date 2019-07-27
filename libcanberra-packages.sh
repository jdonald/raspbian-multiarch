#!/bin/bash -e

# This version conflict seems to come from Debian, not Raspbian

CANBERRA_ARMHF_VERSION="0.30-3+b2"
CANBERRA_ARM64_VERSION="0.30-3"
CANBERRA_PACKAGES="libcanberra0 libcanberra-gtk3-0"

if [ "$(ls libcanberra*_armhf.deb 2> /dev/null | wc -w)" == "2" ]; then
    echo "Normalized libcanberra packages appear to be ready"
    exit 0
fi

apt-get download ${CANBERRA_PACKAGES}

for DEB in libcanberra*_armhf.deb; do
    PKGNAME="${DEB/_*}"
    rm -rf tmp; mkdir -p tmp; cd tmp
    ar xf ../${DEB}
    mkdir newcontrol; cd newcontrol
    tar xf ../control.tar.*
    sed -i "s/${CANBERRA_ARMHF_VERSION}/${CANBERRA_ARM64_VERSION}/g" control
    tar cJf ../control.tar.xz *
    cd .. # leave newcontrol/

    mkdir newdata; cd newdata
    tar xf ../data.tar.*
    rm -f usr/share/doc/${PKGNAME}/changelog.Debian.gz
    tar cJf ../data.tar.xz *
    cd .. # leave newdata/

    ar cr ../"${DEB}" debian-binary control.tar.xz data.tar.xz
    cd .. # leave tmp/
done
echo "Removed rogue +b2 from Debian libcanberra packages"
