#!/bin/bash -e

PROTECTED_PACKAGES="raspberrypi-ui-mods rpi-update pi-package qt5-gtk-platformtheme"

echo "This will leave edits intact under /etc/apt but remove foreign architectures"
echo "and restore the +rpi armhf packages to hopefully make APT happy."
for ARCH in $(dpkg --print-foreign-architectures); do
  sudo dpkg --purge $(dpkg -l | grep " ${ARCH} " | cut -d ' ' -f 3)
  sudo dpkg --remove-architecture "${ARCH}"
done
sudo apt update
sudo apt-get install -y --fix-missing cpp-6 g++-6 gcc-6 libasan3 libatomic1 libcc1-0 libgcc-6-dev libgfortran3 libgomp1 libstdc++-6-dev libstdc++6 libubsan0 ${PROTECTED_PACKAGES}
sudo apt-get autoremove -y

sudo sed -i 's@^#/\(.*\)libarmmem@/\1libarmmem@' /etc/ld.so.preload
