DESCRIPTION = "APDS sensor user application"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/cu-ecen-aeld/final-project-abhirathkoushik-cub.git;protocol=https;branch=main"
SRCREV = "edeb8cf0427d8ee80d6c59d6b39681445dfc9ee5"

S = "${WORKDIR}/git/apds_driver"

inherit module

do_compile() {
    oe_runmake
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/apds_read 	${D}${bindir}/apds_read
    install -m 0755 ${S}/apds_read_file ${D}${bindir}/apds_read_file
}

FILES:${PN} += "${bindir}/apds_read"
FILES:${PN} += "${bindir}/apds_read_file"
