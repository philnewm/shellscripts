#! /bin/bash

source ../lib/permission_utils.sh

test_set_exclusive_owner()
{
    path=$(mktemp -dp ../)
    file=$(mktemp -p "$path")
    local owner=root
    
    touch "$path"
    set_exclusive_rw_owner "$owner" "$file" 
    actual_user=$(stat -c "%U" "$file")

    if [ "$actual_user" != "$owner" ];
    then
        echo "[FAIL]: ${FUNCNAME[0]} owner \"$owner\" not set"
        rm -f "$file"
        rmdir "$path"
        return 1
    fi

    actual_permission=$(stat -c "%a" "$file")

    if [ "$actual_permission" -ne 600 ];
    then
        echo "[FAIL]: ${FUNCNAME[0]} permission \"600\" not set"
        rm -f "$file"
        rmdir "$path"
        return 1
    fi

    echo "[PASS]: ${FUNCNAME[0]}"
    rm -f "$file"
    rmdir "$path"
    return 0
}

test_change_owner_to_user()
{
    path=$(mktemp -dp ../)
    file=$(mktemp -p "$path")
    sudo touch "$file"

    change_owner_to_user "$file"
    actual_user=$(stat -c "%U" "$file")
    wanted_user="$USER"

    if [ "$actual_user" = "$wanted_user" ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        rm "$file"
        rmdir "$path"
        return 0
    fi

    echo "[FAIL] $file_name not owned by $USER"
    sudo rm "$file"
    rmdir "$path"
    return 0
}

test_change_owner_to_root()
{
    path=$(mktemp -dp ../)
    file=$(mktemp -p "$path")
    touch "$file"

    change_owner_to_root "$file"
    actual_user=$(stat -c "%U" "$file")

    if [ "$actual_user" = root ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        sudo rm "$file"
        rmdir "$path"
        return 0
    fi

    echo "[FAIL] $file_name not owned by root"
    rm "$file"
    rmdir "$path"
    return 0
}