#! /usr/bin/bash

source ../lib/file_utils.sh

test_check_file_existence_true()
{
    path=../tmp/
    file_name=some_file

    touch $path$file_name

    if check_file_existence "$path""$file_name";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        rm $path$file_name
        return 0
    fi

    echo "[FAIL] $file_name in $path not detected"
    rm $path$file_name
    return 1
}

test_check_file_existence_false()
{
    path=../tmp/
    file_name=some_file

    if check_file_existence "$path""$file_name";
    then
        echo "[FAIL] $file_name in $path not detected"
        return 0
    fi

    echo "[PASS]: ${FUNCNAME[0]}"
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
    file_name=../tmp/some_file
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
