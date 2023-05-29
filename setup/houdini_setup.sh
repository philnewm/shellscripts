#! /bin/bash

# This file contains a bunch of functions related to setting up houdini.

install_dependencies()
{
    if dnf -q list libnsl 1> /dev/null;
    then
	echo "Package libnsl arleady installed"
	return 0
    fi 

    sudo dnf install libnsl -y
    return 0
}

install_houdini_launcher()
{
    local network_dir=$1
    local setup=$2
    local tmp=$3
    cp "$network_dir" "$tmp"
    cd "$tmp" || return 1
    chmod u+x "$setup"
    sudo ./"$setup" --quiet "/opt/sidefx/launcher"
    # auto install side fx labs
    # license agreement
    rm "$setup"
}

remove_houdini_launcher()
{
    local dir=$1
    cd "$dir" || return 1
    sudo ./uninstall_houdini_launcher.sh
}

install_dependencies
install_houdini_launcher "/mnt/library/system_setup/software_setups/linux/install_houdini_launcher.sh" "install_houdini_launcher.sh" "/tmp/"
# remove_houdini_launcher "/opt/sidefx/launcher"
