#! /bin/bash

# This file contains a bunch of functions related to setting up nomachine.

# WARNING UNTESTED
download_nomachine()
{
    local network_dir=$1
    local setup=$2
    local tmp=$3

	# TODO implement without dependency on smb shares
	cp "$network_dir"/"$setup" "$tmp"

	cd "$tmp" || exit
	sudo rpm -i nomachine*.rpm

	rm -f nomachine*.rpm
}