inherit core-image

# Include SSH capability only
IMAGE_FEATURES += "ssh-server-openssh"

# Install packages for SSH login
CORE_IMAGE_EXTRA_INSTALL += "openssh"

# Root password setup (hashed version of 'root')
inherit extrausers
EXTRA_USERS_PARAMS = "usermod -P root root;"
