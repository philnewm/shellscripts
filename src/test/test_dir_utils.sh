#! /bin/bash

source ../lib/dir_utils.sh

check_dir_existence()
{
    path=../tmp/
    dir_name=some_file

    if check_file_existence "$path""$dir_name";
    then
        echo "[FAIL] $dir_name in $path not detected"
        return 0
    fi

    echo "[PASS]: ${FUNCNAME[0]}"
    return 0
}

test_cleanup_dir()
{
    path=$(mktemp -dp ../)
    dir_name=$(mktemp -dp "$path") || return 1

    cleanup_dir "$dir_name"

    if [ ! -d "$dir_name" ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        rmdir "$path"
        return 0
    fi

    rmdir "$path"
}

test_root_cleanup_dir()
{
    path=$(sudo mktemp -dp ../)
    dir_name=$(sudo mktemp -dp "$path") || return 1

    if cleanup_dir "$dir_name";
    then
        echo "[FAIL] ${FUNCNAME[0]} $USER was able to deleted $dir_name"
        sudo rmdir "$path"
        return 1
    fi

    root_cleanup_dir "$dir_name" "$path"

    if [ ! -d "$dir_name" ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        sudo rmdir "$path"
        return 0
    fi

    sudo rmdir "$path"
}

test_create_dir_as_root()
{
    top_path=$(sudo mktemp -dp ../)
    path=$top_path/sample_dir
    create_dir_as_root "$path"
    dir_owner=$(sudo stat -c "%U" "$path")

    if [ "$dir_owner" = root ];
    then
        echo "[PASS] ${FUNCNAME[0]} \"$path\" created as root"
        sudo rm -R "$path"
        sudo rmdir "$top_path"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} unable to create \"$path\" as root"
    return 1
}