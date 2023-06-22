#! /usr/bin/bash

# This file contains a bunch of functions related to system functionality operations

disable_selinux_temporarily()
{
    sudo setenforce 0
    echo "[OK] Set se_linux to permissive temporarely"
}

enable_selinux_temporarily()
{
    sudo setenforce 1
    echo "[OK] Set se_linux to enforce temporarely"
}

update_system() 
{
	sudo dnf update -y
}

# TODO change SE Linux Settings permanent
# sudo /etc/selinux/config change SELINUX=enforcing to SELINUX=permissive

# TODO check for rpm fusion repo
# TODO change dnf defaults
# https://itsfoss.com/things-to-do-after-installing-fedora/

execute_script_on_login()
{
    path_to_scipt=$1
    echo "$path_to_scipt" >> ~/.bashrc

    cp /usr/share/applications/org.gnome.Terminal.desktop ~/.config/autostart/
}

disable_script_on_login()
{
    path_to_remove=$1

    grep -v "$path_to_remove" ~/.bashrc > ~/.bashrc_temp && mv ~/.bashrc_temp ~/.bashrc

    cd ~/.config/autostart/ || exit 1
    rm org.gnome.Terminal.desktop
}