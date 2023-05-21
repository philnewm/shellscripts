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
    path=../tmp/
    # TODO generate random ID for this test file
    dir_name=test_dir
    mkdir $path$dir_name || return 1

    cleanup_dir "$dir_name" "$path"

    if [ ! -d $path$dir_name ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        return 0
    fi
}

test_root_cleanup_dir()
{
    path=../root_tmp/
    # TODO generate random ID for this test file
    dir_name=test_dir
    sudo mkdir $path$dir_name || return 1

    if cleanup_dir "$dir_name" "$path";
    then
        echo "[FAIL] ${FUNCNAME[0]} $USER was able to deleted $dir_name"
        return 1
    fi

    root_cleanup_dir "$dir_name" "$path"

    if [ ! -d $path$dir_name ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        return 0
    fi
}

test_create_dir_as_root()
{
    local path=../root_tmp/test_dir
    create_dir_as_root "$path"
    dir_owner=$(stat -c "%U" $path)

    if [ "$dir_owner" = root ];
    then
        echo "[PASS] ${FUNCNAME[0]} \"$path\" created as root"
        sudo rm -R $path
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} unable to create \"$path\" as root"
    return 1
}