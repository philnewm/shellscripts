#! /bin/bash

source mount_network_shares.sh
source lib/sys_utils.sh
source lib/driver.sh

# TODO check why sudo -i coesn't wqork right away

update_system
enable_rpm_fusion
install_nvidia_driver
# set basic default configs for gnome (tweaks)
# set default settings for firefox
mount_shares
# install nomachine -> maybe apply settings automatically
# install extensions for DE
# setup environment variables