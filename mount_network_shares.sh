#! /bin/bash

# This file contains a bunch of functions related to mounting network share_mounts on boot

source lib/dir_utils.sh
source lib/file_utils.sh
source lib/network_utils.sh
source lib/permission_utils.sh
source lib/sys_utils.sh

share_mounts=(documents archive library ressources learning)
server_shares=(documents usb_backup library ressources learning)

# TODO add sanity check if defaults got changed
username=testuser
password=testpassword
hosts_file=/etc/hosts
server_address=10.32.64.200
server_name=fileserver
server_string=$(printf "\n#NAS\n%s %s" "$server_address" "$server_name")
credentials_path=$HOME/.smb
mount_dir=mnt
systemd_system_path=/etc/systemd/system/

write_credentials_file()
{
    local username=$1
    local password=$2
    local path=$3

    if ! check_file_existence "$path";
    then
        credentials_content=$(printf "username=%s" "$username")
        credentials_content=$(printf "%s\npassword=%s" "$credentials_content" "$password")
        
        append_string_to_file "$credentials_content" "$path"
        set_exclusive_rw_owner "root" "$path"
        return 0
    fi

    return 1
}

mount_shares()
{
    if [ $username = "testuser" ] || [ $password = "testpassword" ];
    then
        echo "[WARNING] Skipping mount_shares"
        echo "Please change username and password default values"
        return 1
    fi

    write_credentials_file "$username" "$password" "$credentials_path"
    append_string_to_file_as_root "$server_string" "$hosts_file"
    if [ "$(getenforce)" = Enforcing ] > /dev/null;
    then
        touch state
        disable_selinux_temporarily
    fi

    for ((i=0; i<${#share_mounts[@]}; i++));
    do
        mount_path=/$mount_dir/${share_mounts[i]}
        create_dir_as_root "$mount_path"
        
        write_systemd_mount_file "${share_mounts[i]}" "${server_shares[i]}" "$mount_dir" "$server_name" "$systemd_system_path"
        
        write_systemd_auto_mount_file "${share_mounts[i]}" "${server_shares[i]}" "$mount_dir" "$server_name" "$systemd_system_path"
        
        reload_daemon_for_mount_point "${share_mounts[i]}" "$mount_dir"
    done

    if [ -f state ];
    then
        rm -f state
        enable_selinux_temporarily
    fi
}