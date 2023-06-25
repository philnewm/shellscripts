#! /bin/bash

source src/network_setup/mount_network_shares.sh
source src/sys_setup/driver.sh
source src/ui_setup/gnome_config.sh

# TODO check why sudo -i coesn't work right away
tmp_state_path="state/"
gpu_driver_installed_state="state_driver_installed"
theme_extension_installed="state_theme_extension"

# TODO check if exists already 
mkdir "$tmp_state_path"
script_dir=$(pwd)

if [ ! -e "$tmp_state_path$gpu_driver_installed_state" ] && [ ! -e "$tmp_state_path$theme_extension_installed" ];
then
    # change_host_name "Fedora Machine"
    # change_dnf_settings
    sudo dnf update -y
    mount_shares || exit 1
    enable_rpm_fusion
    install_nvidia_driver
    # TODO check auto login enable/disable
    # TODO change default grub config for faster reboot
    cd "$script_dir" || exit 1
    touch "$tmp_state_path$gpu_driver_installed_state"
    sudo reboot
fi

if [ -e "$tmp_state_path$gpu_driver_installed_state" ] && [ ! -e "$tmp_state_path$theme_extension_installed" ];
then
# TODO some gsetting produced error
    setup_gnome_environment
    cd "$script_dir" || exit 1
    touch "$tmp_state_path$theme_extension_installed"
    sudo systemctl restart gdm
fi

# TODO check why coredump
if [ -e "$tmp_state_path$gpu_driver_installed_state" ] && [ -e "$tmp_state_path$theme_extension_installed" ];
then
    activate_themes
fi

# set default settings for firefox
# install nomachine -> maybe apply settings automatically
# install extensions for DE
# setup environment variables