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

# TODO change SE Linux Settings permanent
# sudo /etc/selinux/config change SELINUX=enforcing to SELINUX=permissive

# TODO check for rpm fusion repo
# TODO change dnf defaults
# https://itsfoss.com/things-to-do-after-installing-fedora/

check_for_nvidia_driver()
{
	if nvidia-smi 1>/dev/null 2>&1;
	then
		echo "[INFO] Skipping nvidia driver -> already installed."
		return 0
	fi

	echo "[INFO] No Nvidia Driver installed."
	return 1
}
