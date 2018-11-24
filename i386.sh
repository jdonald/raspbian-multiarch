#!/bin/bash -e

PROTECTED_PACKAGES="raspberrypi-ui-mods rpi-update pi-package qt5-gtk-platformtheme"

if [ ! -e /etc/apt/sources.list.d/debian.list ]; then
    >&2 echo "Debian sources not found. Run ./raspbian-multiarch.sh first"
    exit -1
fi

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y qemu-user libgcc1:i386 gcc-6-base:i386 libc6:i386 ${PROTECTED_PACKAGES}
sudo apt-get purge -y "figlet:*"
sudo apt-get install -y figlet:i386 ${PROTECTED_PACKAGES}
echo "Installed Figlet"

# Wine: The following installation works, but Stretch's wine 1.8 will fail to run without a 3G/1G kernel
# sudo apt-get install -y wine32:i386 libwine:i386 libasound2:i386 libglu1-mesa:i386 libopenal1:i386 libxml2:i386 libgl1-mesa-glx:i386 libstdc++6:i386 libicu57:i386 libglapi-mesa:i386 ${PROTECTED_PACKAGES}
# echo "Installed Wine x86"
# wine "C:\\Windows\\System32\\cmd.exe"

sudo apt-get autoremove -y

file /usr/bin/figlet-figlet
figlet "figlet : i386"
