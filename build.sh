#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.
# Modifiers: Parth Varsani and Abhirath Koushik

git submodule init
git submodule sync
git submodule update

source poky/oe-init-build-env

# Creating the image for RaspberryPi 4B
CONFLINE="MACHINE = \"raspberrypi4\""

# Create image of the type rpi-sdimg
IMAGE="IMAGE_FSTYPES = \"wic.bz2\""

# Set GPU memory as minimum
MEMORY="GPU_MEM = \"16\""

# Enable I2C in Raspberrypi Yocto Build
MODULE_I2C="ENABLE_I2C = \"1\""
AUTOLOAD_I2C="KERNEL_MODULE_AUTOLOAD:rpi += \"i2c-dev i2c-bcm2708\""

# Enable SPI in Raspberrypi Yocto Build
MODULE_SPI="ENABLE_SPI_BUS = \"1\""
AUTOLOAD_SPI="KERNEL_MODULE_AUTOLOAD:rpi += \"spidev\""

# Enable CAN in Raspberrypi Yocto Build
MODULE_CAN="ENABLE_CAN = \"1\""
AUTOLOAD_CAN="KERNEL_MODULE_AUTOLOAD:rpi += \"mcp251x flexcan\""
CAN_OSCILLATOR_CONFIG="CAN_OSCILLATOR = \"8000000\""

# Installing Utility Tools
IMAGE_ADD="IMAGE_INSTALL:append = \" i2c-tools python3 mosquitto can-utils iproute2\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

cat conf/local.conf | grep "${IMAGE}" > /dev/null
local_image_info=$?

cat conf/local.conf | grep "${MEMORY}" > /dev/null
local_memory_info=$?

cat conf/local.conf | grep "${MODULE_I2C}" > /dev/null
local_i2c_info=$?

cat conf/local.conf | grep "${AUTOLOAD_I2C}" > /dev/null
local_i2c_autoload_info=$?

cat conf/local.conf | grep "${MODULE_CAN}" > /dev/null
local_can_info=$?

cat conf/local.conf | grep "${AUTOLOAD_CAN}" > /dev/null
local_can_autoload_info=$?

cat conf/local.conf | grep "${CAN_OSCILLATOR_CONFIG}" > /dev/null
local_can_oscillator_info=$?

cat conf/local.conf | grep "${IMAGE_ADD}" > /dev/null
local_imgadd_info=$?

cat conf/local.conf | grep "${MODULE_SPI}" > /dev/null
local_spi_info=$?

cat conf/local.conf | grep "${AUTOLOAD_SPI}" > /dev/null
local_spi_autoload_info=$?

if [ $local_spi_info -ne 0 ]; then
    echo "Append ${MODULE_SPI} in the local.conf file"
    echo ${MODULE_SPI} >> conf/local.conf
else
    echo "${MODULE_SPI} already exists in the local.conf file"
fi

if [ $local_spi_autoload_info -ne 0 ]; then
    echo "Append ${AUTOLOAD_SPI} in the local.conf file"
    echo ${AUTOLOAD_SPI} >> conf/local.conf
else
    echo "${AUTOLOAD_SPI} already exists in the local.conf file"
fi


if [ $local_conf_info -ne 0 ];then
    echo "Append ${CONFLINE} in the local.conf file"
    echo ${CONFLINE} >> conf/local.conf
else
    echo "${CONFLINE} already exists in the local.conf file"
fi

if [ $local_i2c_info -ne 0 ];then
    echo "Append ${MODULE_I2C} in the local.conf file"
    echo ${MODULE_I2C} >> conf/local.conf
else
    echo "${MODULE_I2C} already exists in the local.conf file"
fi

if [ $local_i2c_autoload_info -ne 0 ];then
    echo "Append ${AUTOLOAD_I2C} in the local.conf file"
    echo ${AUTOLOAD_I2C} >> conf/local.conf
else
    echo "${AUTOLOAD_I2C} already exists in the local.conf file"
fi

if [ $local_can_info -ne 0 ];then
    echo "Append ${MODULE_CAN} in the local.conf file"
    echo ${MODULE_CAN} >> conf/local.conf
else
    echo "${MODULE_CAN} already exists in the local.conf file"
fi

if [ $local_can_autoload_info -ne 0 ];then
    echo "Append ${AUTOLOAD_CAN} in the local.conf file"
    echo ${AUTOLOAD_CAN} >> conf/local.conf
else
    echo "${AUTOLOAD_CAN} already exists in the local.conf file"
fi

if [ $local_can_oscillator_info -ne 0 ];then
    echo "Append ${CAN_OSCILLATOR_CONFIG} in the local.conf file"
    echo ${CAN_OSCILLATOR_CONFIG} >> conf/local.conf
else
    echo "${CAN_OSCILLATOR_CONFIG} already exists in the local.conf file"
fi

if [ $local_image_info -ne 0 ];then 
    echo "Append ${IMAGE} in the local.conf file"
    echo ${IMAGE} >> conf/local.conf
else
    echo "${IMAGE} already exists in the local.conf file"
fi

if [ $local_memory_info -ne 0 ];then
    echo "Append ${MEMORY} in the local.conf file"
    echo ${MEMORY} >> conf/local.conf
else
    echo "${MEMORY} already exists in the local.conf file"
fi

if [ $local_imgadd_info -ne 0 ];then
    echo "Append ${IMAGE_ADD} in the local.conf file"
    echo ${IMAGE_ADD} >> conf/local.conf
else
    echo "${IMAGE_ADD} already exists in the local.conf file"
fi

# Adding meta-raspberrypi layer 
bitbake-layers show-layers | grep "meta-raspberrypi" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
    echo "Adding meta-raspberrypi  layer"
    bitbake-layers add-layer ../meta-raspberrypi
else
    echo "meta-raspberrypi  layer already exists"
fi

# Adding meta-openembedded layer
bitbake-layers show-layers | grep "meta-openembedded" > /dev/null
layer_info_2=$?

if [ $layer_info_2 -ne 0 ];then
    echo "Adding meta-openembedded  layer"
    bitbake-layers add-layer ../meta-openembedded/meta-oe
    bitbake-layers add-layer ../meta-openembedded/meta-python
    bitbake-layers add-layer ../meta-openembedded/meta-networking
else
    echo "meta-openembedded  layer already exists"
fi

bitbake-layers show-layers | grep "meta-application" > /dev/null
layer_app_info=$?

if [ $layer_app_info -ne 0 ];then
    echo "Adding meta-application layer"
    bitbake-layers add-layer ../meta-application
else
    echo "meta-application layer already exists"
fi

set -e
bitbake core-image-base
