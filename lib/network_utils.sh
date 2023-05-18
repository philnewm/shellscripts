#! /usr/bin/bash

# This file contains a bunch of functions related to network operations.    

# TODO find way to test this
reload_daemon_for_mount_point()
{
    local share_mount=$1
    local mount_point=$2
    sudo systemctl daemon-reload

    sudo systemctl enable "$mount_point"-"$share_mount".automount --now
}

write_systemd_mount_file()
{
    # === parameters ===
    local local_mount=$1
    local external_mount=$2
    local mount_point=$3
    local server_name=$4
    local tmp_path=$5
    
    # === settings ===
    local fs_type=cifs
    local mnt_options="credentials=$HOME/.smb,rw,uid=1000,gid=1000,iocharset=utf8,_netdev,noserverino
    DirectoryMode=0700"

    # === combined variables ===
    mount_file="$tmp_path""$mount_point"-"$local_mount"".mount"

    mount_content=$(printf "[Unit]\nDescription=mount %s share\n\n" "$local_mount")

    mount_content=$(printf "%s\n\n[Mount]\nWhat=//%s/%s}\n\n" "$mount_content" "$server_name" "$external_mount")
    mount_content=$(printf "%s\nWhere=/%s/%s\n" "$mount_content" "$mount_point" "$local_mount")
    mount_content=$(printf "%s\nType=%s\n" "$mount_content" "$fs_type")
    mount_content=$(printf "%s\nOptions=%s\n" "$mount_content" "$mnt_options")

    mount_content=$(printf "%s\n\n[Install]\n" "$mount_content")
    mount_content=$(printf "%s\nWantedBy=multi-user.target" "$mount_content")

    # === logic ===
    echo "$mount_content" > "$mount_file"
}

write_systemd_auto_mount_file()
{
    # === parameters ===
    local local_mount=$1
    local external_mount=$2
    local mount_point=$3
    local server_name=$4
    local tmp_path=$5

    # === settings ===
    local idle=60

    auto_mount_content=$(printf "[Unit]\nDescription=mount %s share\n" "$local_mount")
    auto_mount_content=$(printf "%s\n\n[Automount]\nWhere=/%s/%s\n" "$auto_mount_content" "$mount_point" "$local_mount")
    auto_mount_content=$(printf "%s\nTimeoutIdleSec=%s\n\n" "$auto_mount_content" "$idle")
    auto_mount_content=$(printf "%s\n\n[Install]\nWantedBy=multi-user.target" "$auto_mount_content")

    auto_mount_file="$tmp_path""$mount_point"-"$local_mount"".automount"

    echo "$auto_mount_content" > "$auto_mount_file"
}