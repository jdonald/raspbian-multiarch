#!/bin/bash -e

PROTECTED_PACKAGES="raspberrypi-ui-mods rpi-update pi-package pi-package-session qt5-gtk-platformtheme"

./fix-sources.sh
./stealthrpi-packages.sh
./libcanberra-packages.sh
./minetest-data-package.sh
sudo dpkg --install libpam-modules-bin_*_armhf.deb # must precede libpam-modules
sudo dpkg --install *.deb

sudo sed -i 's@^/\(.*\)libarmmem@#/\1libarmmem@' /etc/ld.so.preload # comment out 32-bit LD_PRELOAD

sudo apt install -y libgcc1:arm64 gcc-6-base:arm64 libc6:arm64 ${PROTECTED_PACKAGES} # basic deps
sudo apt install -y libegl1-mesa-dev:arm64 libegl1-mesa:arm64 libwayland-egl1-mesa:arm64 libgbm1:arm64 ${PROTECTED_PACKAGES} # chocolate-doom:arm64 deps
sudo apt install -y libcairo-gobject2:arm64 libcairo2:arm64 libgtk-3-0:arm64 libpangocairo-1.0-0:arm64 libcanberra0:arm64 libdbusmenu-gtk3-4:arm64 libcanberra-gtk3-0:arm64 libasound2:arm64 librest-0.7-0:arm64 libsoup2.4-1:arm64 libwayland-egl1-mesa:arm64 libxml2:arm64 glib-networking:arm64 libegl1-mesa:arm64 libicu57:arm64 libproxy1v5:arm64 libgbm1:arm64 libstdc++6:arm64 ${PROTECTED_PACKAGES} # firefox:arm64 deps
sudo apt install -y libirrlicht1.8:arm64 libjsoncpp1:arm64 libleveldb1v5:arm64 liblua5.1-0:arm64 libopenal1:arm64 libstdc++6:arm64 libgl1-mesa-glx:arm64 libsndio6.1:arm64 libasound2:arm64 libglapi-mesa:arm64 libgl1-mesa-dri:arm64 libllvm3.9:arm64 python-imaging ${PROTECTED_PACKAGES} # minetest:arm64 deps

sudo apt install -y figlet:arm64 ${PROTECTED_PACKAGES}
sudo apt install -y nethack-console:arm64 ${PROTECTED_PACKAGES}
echo "Installed 64-bit NetHack"
sudo apt install -y chocolate-doom:arm64 doom-wad-shareware ${PROTECTED_PACKAGES}
echo "Installed 64-bit DOOM"
sudo apt install -y firefox:arm64 ${PROTECTED_PACKAGES}
echo "Installed Firefox"
sudo apt install -y minetest:arm64 ${PROTECTED_PACKAGES}
echo "Installed Minetest"

PROTECTED_PACKAGES="${PROTECTED_PACKAGES}" ./setup-qemu-user.sh

sudo apt autoremove -y
file /usr/bin/figlet-figlet
figlet "figlet : arm64"
