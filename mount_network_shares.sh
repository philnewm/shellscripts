#! /usr/bin/bash

# This file contains a bunch of functions related to mounting network shares on boot

# TODO check if operation already done
# TODO add echo infos for helpful feedback
createsystemdunitmountfiles()
{
    local -n local_mounts=$1
    local -n external_mounts=$2
    local server_name=$3
    local mount_point=$4
    local tmp_path=$5
    
    # ===> Settngs <===
    local idle=60

    # TODO move variable out of local scope
    local systemd_systempath=/etc/systemd/system/

    for ((i=0; i<${#local_mounts[@]}; i++));
    do
        auto_mount_file="$tmp_path""$mount_point"-"${local_mounts[i]}"".automount"

        # create .automount systemd unit files
        # TODO move into own function
        auto_mount_content=$(printf "[Unit]\nDescription=mount %s share\n" "${local_mounts[i]}")
        auto_mount_content=$(printf "%s\n\n[Automount]\nWhere=/%s/%s\n" "$auto_mount_content" "$mount_point" "${local_mounts[i]}")
        auto_mount_content=$(printf "%s\nTimeoutIdleSec=%s\n\n" "$auto_mount_content" "$idle")
        auto_mount_content=$(printf "%s\n\n[Install]\nWantedBy=multi-user.target" "$auto_mount_content")

        auto_mount_file="$tmp_path""$mount_point"-"${local_mounts[i]}"".automount"

        echo "$auto_mount_content" > "$auto_mount_file"
    done
}

write_systemd_mount_file()
{
    # === parameters ===
    local local_mounts=$1
    local external_mounts=$2
    local tmp_path=$3
    local mount_point=$4
    
    # === settings ===
    local fs_type=cifs
    local mnt_options="credentials=$HOME/.smb,rw,uid=1000,gid=1000,iocharset=utf8,_netdev,noserverino
    DirectoryMode=0700"

    # === combined variables ===
    mount_file="$tmp_path""$mount_point"-"${local_mounts[i]}"".mount"

    mount_content=$(printf "[Unit]\nDescription=mount %s share\n\n" "${local_mounts[i]}")

    mount_content=$(printf "%s\n\n[Mount]\nWhat=//%s/%s}\n\n" "$mount_content" "$server_name" "${external_mounts[i]}")
    mount_content=$(printf "%s\nWhere=/%s/%s\n" "$mount_content" "$mount_point" "${local_mounts[i]}")
    mount_content=$(printf "%s\nType=%s\n" "$mount_content" "$fs_type")
    mount_content=$(printf "%s\nOptions=%s\n" "$mount_content" "$mnt_options")

    mount_content=$(printf "%s\n\n[Install]\n" "$mount_content")
    mount_content=$(printf "%s\nWantedBy=multi-user.target" "$mount_content")

    # === logic ===
    echo "$mount_content" > "$mount_file"
}

move_to_systempath()
{
    local -n share_mounts=$1
    local tmp_path=$2
    local main_path=$3
    local mount_point=$4
    local owner=$5

    for dir in "${share_mounts[@]}"; do
        sudo mv "$tmp_path""$mount_point"-"$dir"".mount" "$main_path""$mount_point"-"$dir"".mount"
        sudo mv "$tmp_path""$mount_point"-"$dir"".automount" "$main_path""$mount_point"-"$dir"".automount"
        
        
        # sudo chown "$owner":"$owner" "$main_path""$mount_point"-"$dir"".mount"
        # sudo chown "$owner":"$owner" "$main_path""$mount_point"-"$dir"".automount"
    done
}

reload_daemon()
{
    local -n share_mounts
    local mount_point
    tempdisablelinux
    sudo systemctl daemon-reload

    for ((i=0; i<${#share_mounts[@]}; i++));
    do
        sudo systemctl enable "$mount_point"-"${share_mounts[i]}".automount --now
    done
}

write_credentials_file()
{
    local username=$1
    local password=$2
    local credentials_file=$3

    credentials_content=$(printf "username=%s" "$username")
    credentials_content=$(printf "%s\npassword=%s" "$credentials_content" "$password")

    echo "$credentials_content" > "$HOME/$credentials_file"
    sudo chown "$owner":"$owner" "$HOME/$credentials_file"
    sudo chmod 600 "$HOME/$credentials_file"
}