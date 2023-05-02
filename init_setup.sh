#! /usr/bin/bash

update_system() 
{
	sude dnf update -y
}

install_nvidia_drivers()
{
	sudo dnf update -y
	sudo dnf install akmod-nvidia -y
	sudo dnf install xorg-x11-drv-nvidia-cuda -y
}

download_nomachine()
{
	# TODO implement without dependecy on smb shares
	cp /mnt/library/system_setup/software_setups/linux/nomachine*.rpm /tmp/

	cd /tmp || exit
	sudo rpm -i nomachine*.rpm

	rm -f nomachine*.rpm
}

update_system
install_nvidia_drivers



download_nomachine


