#! /usr/bin/bash

# This file contains a bunch of functions related to network operations.

add_server_to_hosts()
{
    # === parameters ===
    local server_address=$1
    local server_name=$2
    # TODO find out if system varibale for hosts does exist
    local host_file=$3

    # === combined variables ===
    server_string=$(printf "\n#NAS\n%s %s" "$server_address" "$server_name")

    # === logic ===
    if ! echo "$server_string" | sudo tee -a /etc/hosts > /dev/null; then
        echo "[FAIL] Can't write $server_string to $host_file"
    fi
}

create_mount_point_for_user()
{
    # === parameters ===
    local dir_name=$1
    local path_to_dir=$2

    cd "$path_to_dir" || exit 1

    # === logic ===
    if ! sudo mkdir "$dir_name";
    then
        echo "[Fail] Can't create mount point at \"$path_to_dir$dir_name\""
    fi

    echo "[OK] created mount point at \"$path_to_dir$dir_name\""
}