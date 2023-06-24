#! /bin/bash

source ../lib/network_utils.sh

test_write_systemd_mount_file()
{
    local local_mount=documents
    local external_mount=documents
    tmp_path=$(sudo mktemp -dp ../)/
    local mount_dir=mnt

    mount_file="$tmp_path""$mount_dir"-"$local_mount"".mount"

    write_systemd_mount_file "$local_mount" "$external_mount" "$mount_dir" "fileserver" "$tmp_path"

    if sudo [ -f "$mount_file" ];
    then
        echo "[PASS] ${FUNCNAME[0]} unit file $mount_file created"
        sudo rm -f "$mount_file"
        sudo rmdir "$tmp_path"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} unit file $mount_file not created"
    sudo rmdir "$tmp_path"
    return 1
}

test_write_systemd_auto_mount_file()
{
    local local_mount=documents
    local external_mount=documents
    tmp_path=$(mktemp -dp ../)/
    local mount_dir=mnt

    auto_mount_file="$tmp_path""$mount_dir"-"$local_mount"".automount"

    write_systemd_auto_mount_file "$local_mount" "$external_mount" "$mount_dir" "fileserver" "$tmp_path"
    
    if sudo [ -f "$auto_mount_file" ];
    then
        echo "[PASS] ${FUNCNAME[0]} unit file $auto_mount_file created"
        sudo rm -f "$auto_mount_file"
        sudo rmdir "$tmp_path"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} unit file $auto_mount_file not reated"
    sudo rmdir "$tmp_path"
    return 1
}


