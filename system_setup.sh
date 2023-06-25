#! /bin/bash

source src/network_setup/mount_network_shares.sh
source src/sys_setup/driver.sh

# TODO check why sudo -i doesn't work right away

sudo dnf update -y
enable_rpm_fusion
install_nvidia_driver
# change_host_name "Fedora Machine"
# change_dnf_settings
# set basic default configs for gnome (tweaks)
# set default settings for firefox
mount_shares
# install nomachine -> maybe apply settings automatically
# install extensions for DE
# setup environment variables