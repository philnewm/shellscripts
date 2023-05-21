#! /bin/bash

source ../lib/permission_utils.sh

test_set_exclusive_owner()
{
    local path=../tmp/some_file
    local owner=root
    
    touch "$path"
    set_exclusive_rw_owner "$owner" "$path" 
    actual_user=$(stat -c "%U" $path)

    if [ "$actual_user" != "$owner" ];
    then
        echo "[FAIL]: ${FUNCNAME[0]} owner \"$owner\" not set"
        rm -f $path
        return 1
    fi

    actual_permission=$(stat -c "%a" $path)

    if [ "$actual_permission" -ne 600 ];
    then
        echo "[FAIL]: ${FUNCNAME[0]} permission \"600\" not set"
        rm -f $path
        return 1
    fi

    echo "[PASS]: ${FUNCNAME[0]}"
    rm -f $path
    return 0
}

test_change_owner_to_user()
{
    file_name=../tmp/some_file
    sudo touch $file_name

    change_owner_to_user "$file_name"
    actual_user=$(stat -c "%U" $file_name)
    wanted_user="$USER"

    if [ "$actual_user" = "$wanted_user" ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        rm $file_name
        return 0
    fi

    echo "[FAIL] $file_name not owned by $USER"
    sudo rm $file_name
    return 0
}

test_change_owner_to_root()
{
    local file_name=../tmp/some_file
    touch $file_name

    change_owner_to_root "$file_name"
    actual_user=$(stat -c "%U" $file_name)

    if [ "$actual_user" = root ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        sudo rm $file_name
        return 0
    fi

    echo "[FAIL] $file_name not owned by root"
    rm $file_name
    return 0
}