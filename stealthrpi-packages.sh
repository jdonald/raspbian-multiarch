#!/bin/bash -e

MESA_ARMHF_VERSION="19.1.0~git20190429.9628631a380-1~rpt3"
MESA_ARM64_VERSION="18.3.6-2"

PACKAGES="$(apt list --installed |& grep '+rpi' | sed 's#/.*$##')"
PACKAGE_COUNT=$(wc -w <<< ${PACKAGES})
if [ "${PACKAGE_COUNT}" == "$(ls *+stealthrpi*.deb 2> /dev/null | wc -w)" ]; then
    echo "All stealthrpi packages appear to be here"
    echo "rm *.deb if you wish to regenerate"
    exit 0
fi
echo "Fetching +rpi armhf packages: ${PACKAGES//$'\n'/ }"
apt-get download ${PACKAGES}

for DEB in *+rpi*.deb; do
    PKGNAME="${DEB/_*}"
    rm -rf tmp; mkdir -p tmp; cd tmp
    ar xf ../${DEB}
    mkdir newcontrol; cd newcontrol
    tar xf ../control.tar.*
    if grep -q "${MESA_ARMHF_VERSION}" control; then
        if ! grep -q "${MESA_ARM64_VERSION}" control; then
            sed -i "s/${MESA_ARMHF_VERSION}/${MESA_ARM64_VERSION}/g" control
	fi
    fi
    sed -i 's/+rpi[[:digit:]]//g' control
    tar cJf ../control.tar.xz *
    cd .. # leave newcontrol/

    mkdir newdata; cd newdata
    tar xf ../data.tar.*
    rm -f usr/share/doc/${PKGNAME}/changelog.Debian.gz
    tar cJf ../data.tar.xz *
    cd .. # leave newdata/
    NEW_DEB="${DEB//+rpi/+stealthrpi}"
    ar cr ../"${NEW_DEB}" debian-binary control.tar.xz data.tar.xz
    rm -f ../"${DEB}"

    cd .. # leave tmp/
    echo "Generated ${NEW_DEB}"
done
echo "Successfully generated ${PACKAGE_COUNT} \"stealthrpi\" packages"
