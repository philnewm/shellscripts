#! /bin/bash

# This file contains a bunch of functions related to installing drivers.

source src/lib/sys_utils.sh

install_nvidia_driver()
{
	if check_for_nvidia_driver;
	then
		return 0;
	fi

	sudo dnf install lshw -y

	if echo "$(sudo lshw -c "video" | grep "vendor")"="NVIDIA Coporation";
	then
		sudo dnf install akmod-nvidia -y
		sudo dnf install xorg-x11-drv-nvidia-cuda -y
		return 0
	fi

	echo "No Nvidia GPU found"
	return 1
}