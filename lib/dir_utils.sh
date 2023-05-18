#! /usr/bin/bash

# This file contains a bunch of functions related to directory operations.

cleanup_dir()
{
    # === parameters ===
    local dir_name=$1
    local path=$2

    # === logic ===
    cd "$path" || return 1
    rm -fR "$dir_name" 2>/dev/null || return 1
    echo "[OK] Removed $dir_name from $path"
    return 0
}

root_cleanup_dir()
{
    # === parameters ===
    local dir_name=$1
    local path=$2

    # === logic ===
    cd "$path" || exit
    sudo rm -fR "$dir_name" 2>/dev/null
    echo "[OK] Removed $dir_name from $path using root permissions"
    return 0
}

create_dir_as_root()
{
    local path=$1 
    if sudo mkdir "$path";
    then
        echo "[OK] created dir \"$path\" as root"
        return 0
    fi

    echo "[Fail] Can't create dir \"$path\" as root"
    return 1
}