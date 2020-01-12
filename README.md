# raspbian-multiarch

On a fresh install of Raspbian desktop, run:

    sudo rpi-update

Then edit your /boot/config.txt and add `arm_64bit=1` under the `[pi4]` section, then
reboot.

Next, clone this repo and run:

    ./raspbian-multiarch.sh

This script sets up a hybrid 32-bit / 64-bit user environment.
 
The process should complete in about 20 minutes on a Pi 4B, but will take longer
if you have a slow internet connection and get bottlenecked on downloading packages.

This has been tested on a fresh install of the 2019-09-26 Buster image of Raspbian 
desktop with the 4.19.93+ aarch64 kernel. It was last validated on January 10,
2020 and is likely to break anytime thereafter due to changes in the Raspbian
or Debian repositories.

The key idea here is to work around APT's Draconian multiarch restrictions by
patching the +rpi packages. By tweaking version info and creating these "Stealth RPI"
packages many conflicts are avoided. This is a big hack, but with benefits like
retaining ARMv6 (Pi Zero) compatibility. In the worst case you can fall back with
./undo.sh to install the original +rpi packages.

When not broken, this script even runs on a standard 32-bit Raspbian system image. 
When necessary, it will install **qemu-user** so you can seamlessly run 64-bit commands.
You can try out NetHack and other console commands.
After that point you can consider whether it still makes sense to replace
the kernel for true ARM64 execution. Furthermore, this means you can trial a
system configuration on a Pi 2, Pi Zero, or other boards with 32-bit hardware.

If an error occurs partway through, the *.deb files remain saved for troubleshooting or
manual installation.
