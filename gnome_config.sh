#! /bin/bash

source lib/gnome_utils.sh
source lib/sys_utils.sh

setup_de()
{
    install_ui_tools
    gnome_settings
    tweaks_settings
    nautilus_settings

    # themes
    install_cursor_theme
    install_icon_theme
    install_shell_themes

    enable_user_extension
    
    set_extensions
    activate_themes
}

update_system
setup_de