#! /bin/bash

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

test_check_string_in_file()
{
    local string_content="This is a test"
    local path=../tmp/write_test
    touch $path
    echo "$string_content" >> "$path"

    if check_string_in_file "$string_content" "$path";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} \"$string_content\" not found in \"$path\""
    return 1
}

test_append_string_to_file()
{
    local file_name=../tmp/write_test
    local test_string="This is a test"

    touch "$file_name"

    append_string_to_file "$test_string" "$file_name"

    if grep -Fxq "$test_string" "$file_name";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        rm $file_name
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} \"$test_string\" not written to \"$file_name\""
    rm $file_name
    return 1
}

test_append_string_to_file_as_root()
{
    local file_name=../tmp/write_test
    local test_string="This is a test"

    sudo touch "$file_name"

    append_string_to_file_as_root "$test_string" "$file_name"

    if grep -Fxq "$test_string" "$file_name";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        sudo rm -f $file_name
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} \"$test_string\" not written to \"$file_name\""
    sudo rm -f $file_name
    return 1
}