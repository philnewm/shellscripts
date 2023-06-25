#! /bin/bash

source src/lib/file_utils.sh

execute_script_on_login()
{
    path_to_scipt=$1
    rc_file=~/.bashrc

    if check_string_in_file "$path_to_scipt" "$rc_file";
    then
        echo "[INFO] \"$1\" already written to \"$rc_file\""
    else
        append_string_to_file "$path_to_scipt" "$rc_file"
    fi

    if check_file_existence "$HOME/.config/autostart/org.gnome.Terminal.desktop";
    then
        echo "[INFO] already set up terminal on login"
    else
        cp /usr/share/applications/org.gnome.Terminal.desktop ~/.config/autostart/
    fi

    if check_string_in_file "$path_to_scipt" "$rc_file" && check_file_existence "$HOME/.config/autostart/org.gnome.Terminal.desktop";
    then
        echo "[OK] set up auto-execution on login"
        return 0
    fi

    echo "[FAIL] setting up auto-execution on login failed"
    return 1
}

disable_script_on_login()
{
    path_to_scipt=$1
    rc_file=~/.bashrc

    if check_string_in_file "$path_to_scipt" "$rc_file";
    then
        grep -v "$path_to_scipt" "$rc_file" > ~/.bashrc_temp && mv ~/.bashrc_temp "$rc_file"
    fi

    if check_file_existence "$HOME/.config/autostart/org.gnome.Terminal.desktop";
    then
        cd ~/.config/autostart/ || exit 1
        rm org.gnome.Terminal.desktop
    fi
}