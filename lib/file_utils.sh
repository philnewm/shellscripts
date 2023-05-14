#! /usr/bin/bash

# This file contains a bunch of functions related to file operations

check_file_existence()
{
    # === parameters ===
    local file_name=$1
    local path=$2/

    # === combined variables ===
    local full_path="$path""$file_name"

    # === logic ===
    if [ -f "$full_path" ]; then
        echo "[INFO] Skipping \"$full_path\" -> already exists in \"$path\"."
        return 0
    fi

    return 1
}

cleanup_file()
{
    # === parameters ===
    local filename=$1
    local pathtofile=$2

    # === logic ===
    cd "$pathtofile" || exit
    rm "$filename"
    echo "[OK] Removed $file_name"
}

root_cleanup_file()
{
    # === parameters ===
    local filename=$1
    local pathtofile=$2
    
    # === logic ===
    cd "$pathtofile" || exit
    sudo rm "$filename"
    echo "[OK] Removed $file_name as root"
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