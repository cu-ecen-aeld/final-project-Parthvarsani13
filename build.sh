#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env


# CONFLINE="MACHINE = \"qemuarm64\""
CONFLINE="MACHINE = \"raspberrypi4\""

#Create image of the type rpi-sdimg
IMAGE="IMAGE_FSTYPES = \"wic.bz2\""

#Set GPU memory as minimum
MEMORY="GPU_MEM = \"16\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

cat conf/local.conf | grep "${IMAGE}" > /dev/null
local_image_info=$?

cat conf/local.conf | grep "${MEMORY}" > /dev/null
local_memory_info=$?

MODULE_I2C="ENABLE_I2C = \"1\""
cat conf/local.conf | grep "${MODULE_I2C}" > /dev/null
local_i2c_info=$?

# Autoload I2C_MODULE
AUTOLOAD_I2C="KERNEL_MODULE_AUTOLOAD:rpi += \"i2c-dev i2c-bcm2708\""
cat conf/local.conf | grep "${AUTOLOAD_I2C}" > /dev/null
local_i2c_autoload_info=$?

###############################################################
# Add the following to add i2c-tools support for detecting 
# I2C device
###############################################################
IMAGE_ADD="IMAGE_INSTALL:append = \" i2c-tools python3 mosquitto\""
cat conf/local.conf | grep "${IMAGE_ADD}" > /dev/null
local_imgadd_info=$?

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

# if [ $local_licn_info -ne 0 ];then
#     echo "Append ${LICENCE} in the local.conf file"
# 	echo ${LICENCE} >> conf/local.conf
# else
# 	echo "${LICENCE} already exists in the local.conf file"
# fi

if [ $local_imgadd_info -ne 0 ];then
        echo "Append ${IMAGE_ADD} in the local.conf file"
        echo ${IMAGE_ADD} >> conf/local.conf
else
        echo "${IMAGE_ADD} already exists in the local.conf file"
fi



bitbake-layers show-layers | grep "meta-raspberrypi" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-raspberrypi  layer"
	bitbake-layers add-layer ../meta-raspberrypi
else
	echo "meta-raspberrypi  layer already exists"
fi


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


set -e
bitbake core-image-base
