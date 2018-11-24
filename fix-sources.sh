#!/bin/bash -e

if ! dpkg --print-foreign-architectures | grep -q arm64; then
    sudo dpkg --add-architecture arm64
fi

if [ -e /etc/apt/sources.list.d/debian.list ]; then
    echo "Debian sources appear to be registered"
    exit 0
fi

sudo apt install -y dirmngr
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8B48AD6246925553 # Debian
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6DCF7707EBC211F # Mozilla

sudo cp -vf debian.list /etc/apt/sources.list.d/
if [ ! -e /etc/apt/sources.list.d/firefox.list ]; then
    echo "deb http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/firefox.list
    echo "deb-src http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/firefox-source.list
fi
sudo sed -i 's/deb http/deb [arch=armhf] http/; s/deb-src http/deb [arch=armhf] http/' /etc/apt/sources.list /etc/apt/sources.list.d/raspi.list
echo "Successfully patched /etc/apt/sources.list*"
