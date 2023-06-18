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

enable_rpm_fusion()
{
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y
}

enable_flathub()
{
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# TODO change SE Linux Settings permanent
# sudo /etc/selinux/config change SELINUX=enforcing to SELINUX=permissive

# TODO check for rpm fusion repo
# TODO change dnf defaults
# https://itsfoss.com/things-to-do-after-installing-fedora/