#! /bin/bash

source lib/gnome_utils.sh

setup_de()
{
    install_ui_tools
    gnome_settings
    tweaks_settings
    nautilus_settings
    enable_user_extension

    # themes
    install_cursor_theme
    install_icon_theme
    install_shell_themes
    activate_themes
}