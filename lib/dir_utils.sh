#! /usr/bin/bash

# This file contains a bunch of functions related to directory operations.

check_dir_existence()
{
    # === parameters ===
    local path=$1

    # === logic ===
    if [ -d "$path" ]; then
        echo "[INFO] Skipping \"$path\" -> already exists."
        return 0
    fi

    return 1
}

cleanup_dir()
{
    # === parameters ===
    local dir_path=$1

    # === logic ===
    rm -fR "$dir_path" 2>/dev/null || return 1
    echo "[OK] Removed $dir_path"
    return 0
}

root_cleanup_dir()
{
    # === parameters ===
    local dir_path=$1

    # === logic ===
    sudo rm -fR "$dir_path" 2>/dev/null
    echo "[OK] Removed $dir_path using root permissions"
    return 0
}

create_dir_as_root()
{
    local path=$1

    if [ -d "$path" ]; then
        echo "[INFO] Skipping \"$path\" -> already exists."
        return 0
    fi

    if sudo mkdir "$path";
    then
        echo "[OK] created dir \"$path\" as root"
        return 0
    fi

    echo "[Fail] Can't create dir \"$path\" as root"
    return 1
}