#!/bin/bash -e

MESA_ARMHF_VERSION="19.2.0~rc1-1~bpo10+1~rpt3"
MESA_ARM64_VERSION="18.3.6-2"

DRM_ARMHF_VERSION="2.4.99-1~bpo10~1"
DRM_ARM64_VERSION="2.4.97-1"

PACKAGES="$(apt list --installed |& grep '+rpi\|'${MESA_ARMHF_VERSION}'\|'${DRM_ARMHF_VERSION} | sed 's#/.*$##')"
PACKAGE_COUNT=$(wc -w <<< ${PACKAGES})
if [ "${PACKAGE_COUNT}" == "$(ls *+stealthrpi*.deb 2> /dev/null | wc -w)" ]; then
    echo "All stealthrpi packages appear to be here"
    echo "rm *.deb if you wish to regenerate"
    exit 0
fi
echo "Fetching ${PACKAGE_COUNT} +rpi and mesa armhf packages: ${PACKAGES//$'\n'/ }"
apt-get download ${PACKAGES}

for DEB in *.deb; do
    if [[ ${DEB} == *"+stealthrpi"* ]]; then
        continue
    fi
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
    if grep -q "${DRM_ARMHF_VERSION}" control; then
        if ! grep -q "${DRM_ARM64_VERSION}" control; then
            sed -i "s/${DRM_ARMHF_VERSION}/${DRM_ARM64_VERSION}/g" control
        fi
    fi
    if grep -q "${DRM_ARMHF_VERSION/-*}" control; then
        sed -i "s/${DRM_ARMHF_VERSION/-*}/${DRM_ARM64_VERSION/-*}/g" control
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
    if [[ ${NEW_DEB} != *"+stealthrpi"* ]]; then
        NEW_DEB="${DEB//_armhf/+stealthrpi_armhf}"
    fi
    ar cr ../"${NEW_DEB}" debian-binary control.tar.xz data.tar.xz
    rm -f ../"${DEB}"

    cd .. # leave tmp/
    echo "Generated ${NEW_DEB}"
done
echo "Successfully generated ${PACKAGE_COUNT} \"stealthrpi\" packages"

