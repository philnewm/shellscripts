#! /usr/bin/bash

# This file contains a bunch of functions related to mounting network shares on boot

source /lib/network_utils.sh

server_string=$(printf "\n#NAS\n%s %s" "$server_address" "$server_name")


move_to_systempath()
{
    local share_mount=$1
    local tmp_path=$2
    local main_path=$3
    local mount_point=$4
    local owner=$5

    sudo mv "$tmp_path""$mount_point"-"$share_mount"".mount" "$main_path""$mount_point"-"$share_mount"".mount"
    sudo mv "$tmp_path""$mount_point"-"$share_mount"".automount" "$main_path""$mount_point"-"$share_mount"".automount"
    
    sudo chown "$owner":"$owner" "$main_path""$mount_point"-"$share_mount"".mount"
    sudo chown "$owner":"$owner" "$main_path""$mount_point"-"$share_mount"".automount"
}

write_credentials_file()
{
    local username=$1
    local password=$2
    local path=$3

    credentials_content=$(printf "username=%s" "$username")
    credentials_content=$(printf "%s\npassword=%s" "$credentials_content" "$password")

    append_string_to_file "$credentials_content" 
    sudo chown "$owner":"$owner" "$path"
    sudo chmod 600 "$path"
}

# disable_selinux_temporarily
# credentials
# in loop
# {
# mount-points
# unit files
# move unit files
# reload_daemon_for_mount_point
# }

# reenable_selinux
