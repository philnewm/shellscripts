#! /bin/bash

# This file contains a bunch of functions related to installing drivers.

install_nvidia_driver()
{
	sudo dnf update -y
	sudo dnf install akmod-nvidia -y
	sudo dnf install xorg-x11-drv-nvidia-cuda -y
}