inherit core-image

# Include SSH capability only
IMAGE_FEATURES += "ssh-server-openssh"

# Install packages for SSH login
CORE_IMAGE_EXTRA_INSTALL += "openssh"
CORE_IMAGE_EXTRA_INSTALL += "apds-driver"

# Root password setup (hashed version of 'root')
inherit extrausers
PASSWD = "\$5\$2WoxjAdaC2\$l4aj6Is.EWkD72Vt.byhM5qRtF9HcCM/5YpbxpmvNB5"
EXTRA_USERS_PARAMS = "usermod -p '${PASSWD}' root;"
