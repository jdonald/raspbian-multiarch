#!/bin/bash -e

PROTECTED_PACKAGES="raspberrypi-ui-mods rpi-update pi-package qt5-gtk-platformtheme"

./fix-sources.sh
sudo apt update
./stealthrpi-packages.sh

#./libcanberra-packages.sh
#./minetest-data-package.sh

sudo dpkg --install *.deb

sudo sed -i 's@^/\(.*\)libarmmem@#/\1libarmmem@' /etc/ld.so.preload # comment out 32-bit LD_PRELOAD

sudo apt-get install -y libgcc1:arm64 gcc-8-base:arm64 libc6:arm64 libllvm7:arm64 libstdc++6:arm64 ${PROTECTED_PACKAGES} # basic deps
sudo apt-get install -y libegl1-mesa-dev:arm64 libegl1-mesa:arm64 libwayland-egl1-mesa:arm64 libgbm1:arm64 mesa-common-dev:arm64 libglvnd-dev:arm64 libegl1:arm64 libgl1:arm64 libglx0:arm64 libdrm-dev:arm64 libdrm2:arm64 libdrm-radeon1:arm64 libdrm-nouveau2:arm64 libdrm-amdgpu1:arm64 libdrm-amdgpu1:arm64 libdrm-tegra0:arm64 libdrm-etnaviv1:arm64 libdrm-freedreno1:arm64 libegl-mesa0:arm64 libgbm1:arm64 libglapi-mesa:arm64 libglx-mesa0:arm64 libgl1-mesa-dri:arm64 ${PROTECTED_PACKAGES} # chocolate-doom:arm64 deps

#sudo apt-get install -y libcairo-gobject2:arm64 libcairo2:arm64 libgtk-3-0:arm64 libpangocairo-1.0-0:arm64 libcanberra0:arm64 libdbusmenu-gtk3-4:arm64 libcanberra-gtk3-0:arm64 libasound2:arm64 librest-0.7-0:arm64 libsoup2.4-1:arm64 libwayland-egl1-mesa:arm64 libxml2:arm64 glib-networking:arm64 libegl1-mesa:arm64 libproxy1v5:arm64 libgbm1:arm64 ${PROTECTED_PACKAGES} # firefox:arm64 deps
#sudo apt-get install -y libirrlicht1.8:arm64 libjsoncpp1:arm64 libleveldb1v5:arm64 liblua5.1-0:arm64 libopenal1:arm64 libgl1-mesa-glx:arm64 libsndio6.1:arm64 libasound2:arm64 libglapi-mesa:arm64 libgl1-mesa-dri:arm64 libllvm3.9:arm64 ${PROTECTED_PACKAGES} # minetest:arm64 deps

sudo apt-get install -y figlet:arm64 ${PROTECTED_PACKAGES}
sudo apt-get install -y nethack-console:arm64 ${PROTECTED_PACKAGES}
echo "Installed 64-bit NetHack"
sudo apt-get install -y mesa-utils:arm64 ${PROTECTED_PACKAGES}
echo "Installed glxinfo and glxgears"

#sudo apt-get install -y chocolate-doom:arm64 doom-wad-shareware ${PROTECTED_PACKAGES}
#echo "Installed 64-bit DOOM"
#sudo apt-get install -y firefox:arm64 ${PROTECTED_PACKAGES}
#echo "Installed Firefox"
#sudo apt-get install -y minetest:arm64 ${PROTECTED_PACKAGES}
#echo "Installed Minetest"

PROTECTED_PACKAGES="${PROTECTED_PACKAGES}" ./setup-qemu-user.sh

sudo apt autoremove -y
file /usr/bin/figlet-figlet
figlet "figlet : arm64"
echo "Querying 64-bit GL and GLES profiles, probably software rendering:"
glxinfo | egrep --color=none "Vendor|Device|GLES\[23\]"
if [ "$(uname -m)" == "aarch64" ]; then
    echo "Downloading and unpacking custom Mesa 19.3 binaries"
    curl -Lo- https://www.dropbox.com/s/yjpez224cotk3tj/mesa-v3d_19.3-EXT_buffer_storage_arm64.tar.xz?dl=0 | sudo tar -xJf- -C /
    glxinfo | egrep --color=none "Vendor|Device|GLES\[23\]"
    echo "If that looks okay, try running arm64 glxgears"
fi

#echo "Next, run ./i386.sh if you want i386 packages too"
