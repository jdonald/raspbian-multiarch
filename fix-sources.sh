#!/bin/bash -e

if ! dpkg --print-foreign-architectures | grep -q arm64; then
    sudo dpkg --add-architecture arm64
fi

if [ -e /etc/apt/sources.list.d/debian.list ]; then
    echo "Debian sources appear to be registered"
    exit 0
fi

sudo apt install -y dirmngr
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC # Debian
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50 # Debian security

sudo cp -vf debian.list /etc/apt/sources.list.d/
sudo sed -i 's/deb http/deb [arch=armhf] http/; s/deb-src http/deb-src [arch=armhf] http/' /etc/apt/sources.list /etc/apt/sources.list.d/raspi.list
echo "Successfully patched /etc/apt/sources.list*"
