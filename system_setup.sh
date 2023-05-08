#! /usr/bin/bash

mount_points=(documents archive library ressources learning)
server_shares=(documents usb_backup library ressources learning)
server_name=fileserver
server_address=10.32.64.200
tmp_path=/tmp/
mount_dir=mnt
# TODO change dir to systemd system path
system_path=/etc/systemd/system/

# shellcheck source=mount_network_shares.sh
source mount_network_shares.sh

if ! createmountpointsforuser share_mounts /mnt/;
then
    cleanupdirs share_mounts /mnt/
fi

addservertohosts $server_address $server_name "/etc/hosts"

createsystemdunitmountfiles mount_points server_shares $server_name $mount_dir $tmp_path

movetosystempath mount_points $tmp_path $system_path $mount_dir

reloaddaemon mount_points $mount_dir

