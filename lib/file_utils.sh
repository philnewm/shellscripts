#! /usr/bin/bash

# This file contains a bunch of functions related to file operations

check_file_existence()
{
    # === parameters ===
    local path=$1

    # === logic ===
    if [ -f "$path" ]; then
        echo "[INFO] Skipping \"$path\" -> already exists."
        return 0
    fi

    return 1
}

root_change_owner_to_user()
{
    # === parameters ===
    local file_name=$1
    local path=$2

    # === logic ===
    if ! sudo chown "$USER":"$USER" "$file_name";
    echo "[OK] Changed owner of $file_name to $USER"
    then
        echo "[FAIL] Can't change owner for \"$file_name\" to user \"$USER\""
    fi
}

root_change_owner_to_root()
{
    # === parameters ===
    local file_name=$1
    local path=$2

    # === logic ===
    if ! sudo chown root:root "$file_name";
    echo "[OK] Changed owner of $file_name to $USER"
    then
        echo "[FAIL] Can't change owner for \"$file_name\" to user \"$USER\""
    fi
}