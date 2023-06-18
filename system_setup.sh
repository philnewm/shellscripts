#! /bin/bash

source mount_network_shares.sh

update_system
enable_rpm_fusion
install_nvidia_driver
# set basic default configs for gnome (tweaks)
# set default settings for firefox
mount_shares
