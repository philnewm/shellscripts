#! /bin/bash

source mount_network_shares.sh
source lib/sys_utils.sh
source lib/driver.sh
source gnome_config

# TODO check why sudo -i coesn't work right away
tmp_state_path="state/"
gpu_driver_installed_state="state_driver_installed"
theme_extension_installed="state_theme_extension"

if [ ! -e "$($tmp_state_path$gpu_driver_installed_state)" ] && [ ! -e "$($tmp_state_path$theme_extension_installed)" ];
then
    update_system
    install_nvidia_driver
    # TODO check outo login enable/disable
    # TODO change default grub config for faster reboot
    mount_shares
    touch "$($tmp_state_path$gpu_driver_installed_state)"
    sudo reboot
fi

if [ -e "$($tmp_state_path$gpu_driver_installed_state)" ] && [ ! -e "$($tmp_state_path$theme_extension_installed)" ];
then
    setup_gnome_environment
    touch "$($tmp_state_path$theme_extension_installed)"
    sudo systemctl restart gdm
fi

if [ -e "$($tmp_state_path$gpu_driver_installed_state)" ] && [ -e "$($tmp_state_path$theme_extension_installed)" ];
then
    activate_themes
fi

# set default settings for firefox
# install nomachine -> maybe apply settings automatically
# install extensions for DE
# setup environment variables