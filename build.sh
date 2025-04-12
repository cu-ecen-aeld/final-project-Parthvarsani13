#!/bin/bash
# Script to build Yocto image for Raspberry Pi 4
# Author: Parth Varsani <parth.varsani@colorado.edu>

git submodule init
git submodule sync
git submodule update

# Set up build environment
source poky/oe-init-build-env

# Local.conf settings to ensure are present
CONFLINES=(
    'MACHINE = "raspberrypi4"'
    'IMAGE_FSTYPES = "wic.bz2"'
    'GPU_MEM = "16"'
    'KERNEL_MODULES:append = " i2c-dev "'                     # Add I2C character device
    'KERNEL_MODULE_AUTOLOAD:rpi += "i2c-dev"'                # Auto-load i2c-dev module
    'IMAGE_INSTALL:append = " i2c-tools python3 mosquitto "' # Tools for testing
)

for line in "${CONFLINES[@]}"; do
    grep -Fxq "$line" conf/local.conf || echo "$line" >> conf/local.conf
done

# Required layers
BBLAYERS_ADD=(
    '../meta-raspberrypi'
    '../meta-openembedded/meta-oe'
    '../meta-openembedded/meta-python'
    '../meta-openembedded/meta-networking'
)

for layer in "${BBLAYERS_ADD[@]}"; do
    bitbake-layers show-layers | grep "$(basename "$layer")" > /dev/null
    if [ $? -ne 0 ]; then
        echo "Adding $layer"
        bitbake-layers add-layer "$layer"
    else
        echo "$layer already exists"
    fi
done

# Exit on error
set -e

# Build the image
bitbake core-image-base

