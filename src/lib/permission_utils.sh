#! /bin/bash

# This file contains a bunch of functions related to file permissions

set_exclusive_rw_owner()
{
    local owner=$1
    local path=$2 

    sudo chown "$owner":"$owner" "$path"
    sudo chmod 600 "$path"
}

change_owner_to_user()
{
    # === parameters ===
    local path=$1

    # === logic ===
    if sudo chown "$USER":"$USER" "$path";
    then
        echo "[OK] Changed owner of \"$path\" to \"$USER\""
        return 0
    fi

    echo "[FAIL] Can't change owner for \"$path\" to user \"$USER\""
    return 1
}

change_owner_to_root()
{
    # === parameters ===
    local path=$1

    # === logic ===
    if sudo chown root:root "$path";
    then
        echo "[OK] Changed owner of $path to root"
        return 0
    fi

    echo "[FAIL] Can't change owner for \"$path\" to user root"
    return 1
}