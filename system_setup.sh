#! /bin/bash

source mount_network_shares.sh
source /lib/sys_utils.sh

update_system
# check and install nvidia driver
# set basic default configs for gnome (tweaks)
# set default settings for firefox
mount_shares
# install nomachine -> maybe apply settings automatically
# install extensions for DE
# setup environment variables