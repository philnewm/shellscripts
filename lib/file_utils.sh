#! /bin/bash

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

check_string_in_file()
{
    # === parameters ===
    local search_string=$1
    local path=$2

    # === logic ===
    if grep -Fxq "$search_string" "$path";
    then
        echo "[INFO] \"$search_string\" already exists in \"$path\""
        return 0
    fi

    return 1
}

append_string_to_file()
{
    # === parameters ===
    local input_string=$1
    local file_name=$2

    # === logic ===
    if ! echo "$input_string" >> "$file_name"; then
        echo "[FAIL] Can't write \"$input_string\" to \"$file_name\""
        return 1
    fi

    return 0
}

append_string_to_file_as_root()
{
    # === parameters ===
    local input_string=$1
    local file_name=$2

    if grep -Fxq "$input_string" "$file_name";
    then
        echo "skipping \"$input_string\" already found in file \"$file_name\""
        return 0
    fi

    # === logic ===
    if ! echo "$input_string" | sudo tee -a "$file_name" > /dev/null; then
        echo "[FAIL] Can't write \"$input_string\" to \"$file_name\""
        return 1
    fi

    return 0
}