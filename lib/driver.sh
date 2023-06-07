#! /bin/bash

# This file contains a bunch of functions related to installing drivers.

source sys_utils.sh

install_nvidia_driver()
{
	# TODO check if nvidia card is present
	if $(lshw -c video | grep vendor)="NVIDIA Coporation";
	then
		if nvidia-smi;
		then
			echo "[INFO] Skipping nvidia driver -> already installed."
			return 0
		fi

		update_system

		if nvidia-msi;
		then
			return 0
		fi

		sudo dnf install akmod-nvidia -y
		sudo dnf install xorg-x11-drv-nvidia-cuda -y
		return 0
	fi

	echo "No Nvidia GPU found"
	return 1
}