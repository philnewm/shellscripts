#! /bin/bash

# This file contains a bunch of functions related to mounting network share_mounts on boot

source /lib/file_utils.sh
source /lib/permission_utils.sh
source /lib/sys_utils.sh

share_mounts=(documents archive library ressources learning)
server_shares=(documents usb_backup library ressources learning)
hosts_file=/etc/hosts
server_address=10.32.64.200
server_name=fileserver
server_string=$(printf "\n#NAS\n%s %s" "$server_address" "$server_name")
mount_dir=mnt
tmp_path=/tmp/
systemd_system_path=/tmp/
# /etc/systemd/system/

move_to_systempath()
{
    local share_mount=$1
    local tmp_path=$2
    local main_path=$3
    local mount_dir=$4
    local owner=$5

    sudo mv "$tmp_path""$mount_dir"-"$share_mount"".mount" "$main_path""$mount_dir"-"$share_mount"".mount"
    sudo mv "$tmp_path""$mount_dir"-"$share_mount"".automount" "$main_path""$mount_dir"-"$share_mount"".automount"
    
    sudo chown "$owner":"$owner" "$main_path""$mount_dir"-"$share_mount"".mount"
    sudo chown "$owner":"$owner" "$main_path""$mount_dir"-"$share_mount"".automount"
}

write_credentials_file()
{
    local username=$1
    local password=$2
    local path=$3

    if ! check_file_existence "$path";
    then
        credentials_content=$(printf "username=%s" "$username")
        credentials_content=$(printf "%s\npassword=%s" "$credentials_content" "$password")

        append_string_to_file "$credentials_content"
        set_exclusive_rw_owner "root" "$path"
        return 0
    fi

    echo "skipping \"$path\" already exists"
    return 1
}

write_credentials_file "$username" "$password"
append_string_to_file_as_root "$server_string" "$hosts_file"
disable_selinux_temporarily

for ((i=0; i<${#share_mounts[@]}; i++));
do
    mount_path=/$mount_dir/${share_mounts[i]}
    create_dir_as_root "$mount_path"

    write_systemd_mount_file "${share_mounts[i]}" "${server_shares[i]}" "$mount_dir" "$server_name" "$systemd_system_path"

    write_systemd_mount_file "${share_mounts[i]}" "${server_shares[i]}" "$mount_dir" "$server_name" "$systemd_system_path"

    # reload_daemon_for_mount_point "${share_mounts[i]}" "$mount_dir"
done

enable_selinux_temporarily
