#! /bin/bash

source lib/gnome_utils.sh
source lib/sys_utils.sh

setup_gnome_environment()
{
    # gnome settings
    install_ui_tools
    gnome_settings
    tweaks_settings
    nautilus_settings

    # themes
    install_cursor_theme
    install_icon_theme
    install_shell_themes
}

activate_themes()
{
    set_extensions
    activate_themes
}