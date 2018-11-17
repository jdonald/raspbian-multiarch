#!/bin/bash -e

MESA_ARMHF_VERSION="13.0.6-1"
MESA_ARM64_VERSION="13.0.6-1+b2"

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
    tar xf ../control.tar.gz
    if grep -q "${MESA_ARMHF_VERSION}" control; then
        if ! grep -q "${MESA_ARM64_VERSION}" control; then
            sed -i "s/${MESA_ARMHF_VERSION}/${MESA_ARM64_VERSION}/g" control
        fi
    fi
    sed -i 's/+rpi[[:digit:]]//g' control
    tar czf ../control.tar.gz *
    cd .. # leave newcontrol/

    mkdir newdata; cd newdata
    tar xf ../data.tar.*
    rm -f usr/share/doc/${PKGNAME}/changelog.Debian.gz
    tar czf ../data.tar.gz *
    cd .. # leave newdata/
    NEW_DEB="${DEB//+rpi/+stealthrpi}"
    ar cr ../"${NEW_DEB}" debian-binary control.tar.gz data.tar.gz
    rm -f ../"${DEB}"

    cd .. # leave tmp/
    echo "Generated ${NEW_DEB}"
done
echo "Successfully generated ${PACKAGE_COUNT} \"stealthrpi\" packages"
