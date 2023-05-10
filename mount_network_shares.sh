#! /usr/bin/bash

# TODO check if operation already done
# TODO add echo infos for helpfull feedback
createsystemdunitmountfiles()
{
    local -n local_mounts=$1
    local -n external_mounts=$2
    local server_name=$3
    local mount_point=$4
    local tmp_path=$5
    
    # ===> Settngs <===
    local idle=60
    local fs_type=cifs
    local mnt_options="credentials=$HOME/.smb,rw,uid=1000,gid=1000,iocharset=utf8,_netdev,noserverino
    DirectoryMode=0700"

    for ((i=0; i<${#local_mounts[@]}; i++));
    do
        # create .mount systemd unit files
        # TODO move into own function
        mount_content=$(printf "[Unit]\nDescription=mount %s share\n\n" "${local_mounts[i]}")

        mount_content=$(printf "%s\n\n[Mount]\nWhat=//%s/%s}\n\n" "$mount_content" "$server_name" "${external_mounts[i]}")
        mount_content=$(printf "%s\nWhere=/%s/%s\n" "$mount_content" "$mount_point" "${local_mounts[i]}")
        mount_content=$(printf "%s\nType=%s\n" "$mount_content" "$fs_type")
        mount_content=$(printf "%s\nOptions=%s\n" "$mount_content" "$mnt_options")

        mount_content=$(printf "%s\n\n[Install]\n" "$mount_content")
        mount_content=$(printf "%s\nWantedBy=multi-user.target" "$mount_content")
        
        mount_file="$tmp_path""$mount_point"-"${local_mounts[i]}"".mount"

        echo "$mount_content" > "$mount_file"

        # create .automount systemd unit files
        # TODO move into own function
        auto_mount_content=$(printf "[Unit]\nDescription=mount %s share\n" "${local_mounts[i]}")
        auto_mount_content=$(printf "%s\n\n[Automount]\nWhere=/%s/%s\n" "$auto_mount_content" "$mount_point" "${local_mounts[i]}")
        auto_mount_content=$(printf "%s\nTimeoutIdleSec=%s\n\n" "$auto_mount_content" "$idle")
        auto_mount_content=$(printf "%s\n\n[INSTALL]\nWantedBy=multi-user.target" "$auto_mount_content")

        auto_mount_file="$tmp_path""$mount_point"-"${local_mounts[i]}"".automount"

        echo "$auto_mount_content" > "$auto_mount_file"
    done
}

movetosystempath()
{
    local -n share_mounts=$1
    local tmp_path=$2
    local main_path=$3
    local mount_point=$4
    local owner=$5

    for dir in "${share_mounts[@]}"; do
        sudo mv "$tmp_path""$mount_point"-"$dir"".mount" "$main_path""$mount_point"-"$dir"".mount"
        sudo mv "$tmp_path""$mount_point"-"$dir"".automount" "$main_path""$mount_point"-"$dir"".automount"
        sudo chown "$owner":"$owner" "$main_path""$mount_point"-"$dir"".mount"
        sudo chown "$owner":"$owner" "$main_path""$mount_point"-"$dir"".automount"
    done
}

addservertohosts()
{
    local server_address=$1
    local server_name=$2
    # TODO find out if system varibale for hosts does exist
    local host_file=$3
    server_string=$(printf "\n#NAS\n%s %s" "$server_address" "$server_name")
    if ! echo "$server_string" | sudo tee -a /etc/hosts > /dev/null; then
        echo "failed writing $server_string to $host_file"
    fi
}

changedirowner()
{
    local dir=$1
    local owner=$2

    chown "$owner":"$owner" $dir
}

createmountpointforuser()
{
    local -n dirname=$1
    local pathtodir=$2

    cd "$pathtodir" || exit 1

    for dir in "${dirname[@]}"; do
        if ! sudo mkdir "$dir";
        then
            echo "Failed to create mount point at \"$pathtodir$dir\""
        fi

        echo "created mount point at \"$pathtodir$dir\""

        if ! sudo chown "$USER":"$USER" "$dir";
        then
            echo "failed to change owner for \"$dir\" to user \"$USER\""
        fi
    done
}

cleanupdirs()
{
    local -n dirname=$1
    local pathtodir=$2
    cd "$pathtodir" || exit
    for ((i=0; i<${#share_mounts[@]}; i++));
    do
        # create mount points
        sudo rm -r "${dirname[i]}"
    done
}

cleanupfiles()
{
    local filename=$1
    local pathtofile=$2
    cd "$pathtofile" || exit
    for ((i=0; i<${#share_mounts[@]}; i++));
    do
        # create mount points
        sudo rm -r "${filename[i]}"
    done
}

reloaddaemon()
{
    local -n share_mounts
    local mount_point
    sudo systemctl daemon-reload

    for ((i=0; i<${#share_mounts[@]}; i++));
    do
        sudo systemctl enable "$mount_point"-"${share_mounts[i]}".automount --now
    done
}

writecredentials()
{
    local username=$1
    local password=$2
    local credentials_file=$3

    credentials_content=$(printf "username=%s" "$username")
    credentials_content=$(printf "%s\npassword=%s" "$credentials_content" "$password")

    echo "$credentials_content" > "$HOME/$credentials_file"
    # TODO change owner to ROOT + change permissions to 600
}