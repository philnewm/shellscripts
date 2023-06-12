#! /bin/bash

# This file contains a bunch of functions related to installing drivers.

source lib/sys_utils.sh

install_nvidia_driver()
{
	if echo "$(sudo lshw -c "video" | grep "vendor")"="NVIDIA Coporation";
	then
		if nvidia-smi 1>/dev/null 2>&1;
		then
			echo "[INFO] Skipping nvidia driver -> already installed."
			return 0
		fi

		update_system

		sudo dnf install akmod-nvidia -y
		sudo dnf install xorg-x11-drv-nvidia-cuda -y
		return 0
	fi

	echo "No Nvidia GPU found"
	return 1
}