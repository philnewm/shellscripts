#! /bin/bash

source ../lib/file_utils.sh

test_check_file_existence_true()
{
    path=$(mktemp -dp ../)
    file=$(mktemp -p "$path")

    if check_file_existence "$file";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        rm "$file"
        rmdir "$path"
        return 0
    fi

    echo "[FAIL] $file not detected"
    rm "$file" | exit 1
    rmdir "$path" | exit 1
    return 1
}

test_check_file_existence_false()
{
    path=$(mktemp -dp ../)
    file=$(mktemp -p "$path")
    rm "$file"
    rmdir "$path"

    if check_file_existence "$path"/"$file";
    then
        echo "[FAIL] ${FUNCNAME[0]} $file_name in $path detected"
        return 0
    fi

    echo "[PASS]: ${FUNCNAME[0]}"
    return 0
}

test_check_string_in_file()
{
    path=$(mktemp -dp ../)
    local string_content="This is a test"
    file=$(mktemp -p "$path")
    touch "$file"
    echo "$string_content" >> "$file"

    if check_string_in_file "$string_content" "$file";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        rm "$file"
        rmdir "$path"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} \"$string_content\" not found in \"$file\""
    rm "$file"
    rmdir "$path"
    return 1
}

test_append_string_to_file()
{
    path=$(mktemp -dp ../)
    file=$(mktemp -p "$path")
    local test_string="This is a test"

    touch "$file"

    append_string_to_file "$test_string" "$file"

    if grep -Fxq "$test_string" "$file";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        rm "$file"
        rmdir "$path"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} \"$test_string\" not written to \"$file_name\""
    rm "$file"
    rmdir "$path"
    return 1
}

test_append_string_to_file_as_root()
{
    path=$(sudo mktemp -dp ../)
    file=$(sudo mktemp -p "$path")
    local test_string="This is a test"

    sudo touch "$file"

    append_string_to_file_as_root "$test_string" "$file"

    if sudo grep -Fxq "$test_string" "$file";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        sudo rm -f "$file"
        sudo rmdir "$path"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} \"$test_string\" not written to \"$file\""
    sudo rm -f "$file"
    sudo rmdir "$path"
    return 1
}