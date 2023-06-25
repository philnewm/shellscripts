#! /bin/bash

source src/sys_setup/autostart.sh
source src/lib/file_utils.sh

test_disable_script_on_login()
{
    rc_file=~/.bashrc
    execute_script_on_login "$0"
    disable_script_on_login "$0"

    if check_string_in_file "$0" "$rc_file" && check_file_existence "$HOME/.config/autostart/org.gnome.Terminal.desktop";
    then
        echo "[FAIL] ${FUNCNAME[0]}"
        return 1
    fi

    echo "[PASS] ${FUNCNAME[0]}"
    return 1
}

test_execute_script_on_login()
{
    rc_file=~/.bashrc
    execute_script_on_login "$0"

    if check_string_in_file "$0" "$rc_file" && check_file_existence "$HOME/.config/autostart/org.gnome.Terminal.desktop";
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        disable_script_on_login "$0"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]}"
    return 1
}