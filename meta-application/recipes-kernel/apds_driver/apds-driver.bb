DESCRIPTION = "APDS Motion Sensor I2C Kernel Driver + DT Overlay"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/cu-ecen-aeld/final-project-abhirathkoushik-cub.git;protocol=https;branch=main"
SRCREV = "ec494fb62d5639d81511a20dfab2f11b7978f345"

S = "${WORKDIR}/git/apds_driver"

inherit module

DEPENDS += "dtc-native"

EXTRA_OEMAKE = "KERNELDIR=${STAGING_KERNEL_DIR}"

# Build both .ko and .dtbo
do_compile:append() {
    oe_runmake dtbo
}

# Install .ko and .dtbo properly
do_install() {
    # Install Kernel Module
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/
    install -m 0644 ${S}/apds_driver.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/

    # Install Device Tree Overlay
    install -d ${D}${sysconfdir}/boot/overlays/
    install -m 0644 ${S}/apds-overlay.dtbo ${D}${sysconfdir}/boot/overlays/
}

# Tell Yocto to deploy .dtbo file correctly
FILES:${PN} += "${sysconfdir}/boot/overlays/apds-overlay.dtbo"

