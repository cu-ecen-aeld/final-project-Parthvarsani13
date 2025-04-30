# See https://git.yoctoproject.org/poky/tree/meta/files/common-licenses
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# TODO: Set this  with the path to your assignments rep.  Use ssh protocol and see lecture notes
# about how to setup ssh-agent for passwordless acces
#SRC_URI = "git://github.com/cu-ecen-aeld/assignments-3-and-later-Parthvarsani13.git;protocol=ssh;branch=main"
SRC_URI = "git://github.com/cu-ecen-aeld/final-project-abhirathkoushik-cub.git;protocol=https;branch=main"

PV = "1.0+git${SRCPV}"
# TODO: set to reference a specific commit hash in your assignment repo
SRCREV = "e909df2e36534fcccacb9a39552b1f74215d8ac8"

# This sets your staging directory based on WORKDIR, where WORKDIR is defined at 
# https://docs.yoctoproject.org/ref-manual/variables.html?highlight=workdir#term-WORKDIR
# We reference the "server" directory here to build from the "server" directory
# in your assignments repo
S = "${WORKDIR}/git"

# TODO: Add the aesdsocket application and any other files you need to install
# See https://git.yoctoproject.org/poky/plain/meta/conf/bitbake.conf?h=kirkstone
FILES:${PN} += "${bindir}/server_node.sh"
FILES:${PN} += "${bindir}/client_node.sh"
FILES:${PN} += "${bindir}/apds_can_control"
FILES:${PN} += "${bindir}/can_tx_from_file"

FILES:${PN} += "${bindir}/socket_can_client"
FILES:${PN} += "${bindir}/socket_can_server"

FILES:${PN} += "${bindir}/tx_server"
FILES:${PN} += "${bindir}/rx_client"
do_configure () {
	:
}

do_compile () {

	oe_runmake
}

do_install () {
	
	install -d ${D}${bindir}

	install -m 0777 ${S}/server_node.sh	${D}${bindir}/
	install -m 0777 ${S}/client_node.sh 	${D}${bindir}/
	install -m 0777 ${S}/apds_can_control 	${D}${bindir}/
	install -m 0777 ${S}/can_tx_from_file 	${D}${bindir}/

	install -m 0777 ${S}/socket_can_client 	${D}${bindir}/
	install -m 0777 ${S}/socket_can_server 	${D}${bindir}/
	install -m 0777 ${S}/rx_client 	${D}${bindir}/
	install -m 0777 ${S}/tx_server 	${D}${bindir}/
}
