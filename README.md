# raspbian-multiarch

On a fresh Raspbian installation, clone this repo and run:

    ./raspbian-multiarch.sh

This script sets up a hybrid 32-bit / 64-bit user environment, so a great starting
image is [Raspbian with a 64-bit kernel](https://github.com/Crazyhead90/pi64/releases).
The process should complete in about 10 minutes on a Pi 3B+, but will take longer
if you have a slow internet connection and get bottlenecked on downloading packages.

The key idea here is to work around APT's Draconian multiarch restrictions by
patching the +rpi packages. By tweaking version info and creating these "Stealth RPI"
packages many conflicts are avoided. This is a big hack, but with benefits like
retaining ARMv6 (Pi Zero) compatibility. In the worst case you can fall back by
reinstalling the original +rpi packages.

This script even runs on a standard 32-bit Raspbian system image. When necessary, it
will install **qemu-user** so you can seamlessly run 64-bit commands. Heavy
graphical applications won't work in emulation, but try out Nethack and other console
commands. After that point you can consider whether it still makes sense to replace
the kernel for true ARM64 execution.

If an error occurs partway through, the *.deb files remain saved for troubleshooting or
manual installation. Each helper script is designed to detect past progress and avoid
repeating slow parts if attempted a second time.
