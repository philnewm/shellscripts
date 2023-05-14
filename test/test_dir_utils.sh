#! /usr/bin/bash

source ../lib/dir_utils.sh

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
        echo "[FAIL] $USER was able to deleted $dir_name"
        return 1
    fi

    root_cleanup_dir "$dir_name" "$path"

    if [ ! -d $path$dir_name ];
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        return 0
    fi
}