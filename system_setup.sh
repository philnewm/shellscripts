#! /bin/bash

source mount_network_shares.sh
source lib/sys_utils.sh
source lib/driver.sh

# TODO check why sudo -i coesn't wqork right away

start_state="state_start"
initial_update_state="state_initial_update"
gpu_driver_installed_state="state_driver_installed"
theme_extension_installed="state_theme_extension"

if [ ! -e "state_start" ];
then
    update_system
    install_nvidia_driver
    # TODO write into cron tab and remove after execution again
    # TODO check outo login enable/disable
    # TODO change default grub config for faste reboot
fi

# set basic default configs for gnome (tweaks)
# set default settings for firefox
mount_shares
# install nomachine -> maybe apply settings automatically
# install extensions for DE
# setup environment variables