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

