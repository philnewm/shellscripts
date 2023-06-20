#! /bin/bash

install_ui_tools()
{
    sudo dnf install gnome-tweaks -y
    sudo dnf install ulauncher -y
    sudo dnf install gnome-extensions-app -y
}

tweaks_settings()
{
    gsettings set org.gnome.tweaks show-extensions-notice false

    # fonts
    gsettings set org.gnome.desktop.interface font-name 'Cantarell Bold 11'
    gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 11'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro 10'
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Carlito Bold Italic 11'
    
    #keyboard mouse
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:none']"

    #top bar
    gsettings set org.gnome.desktop.interface clock-show-weekday true

    # title bars
    gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
    gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'

    # windows
    gsettings set org.gnome.mutter attach-modal-dialogs false
}

enable_user_extension()
{
    sudo dnf install gnome-shell-extension-user-theme -y
    gnome-session-quit
}

set_extensions()
{
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    gnome-extensions disable background-logo@fedorahosted.org
}

activate_themes()
{
    gsettings set org.gnome.desktop.interface cursor-theme 'Qogir'
    gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-purple-dark'
    gsettings set org.gnome.shell.extensions.user-theme name 'Lavanda-Dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Lavanda-Dark'
}

install_shell_themes()
{    
    sudo dnf install gtk-murrine-engine -y
    sudo dnf install sassc -y
    git clone https://github.com/vinceliuice/Lavanda-gtk-theme.git /tmp/theme/
    cd /tmp/theme || exit 1
    ./install.sh
    cd ..
    rm -fR theme
}

install_icon_theme()
{
    git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git /tmp/icon_theme
    cd /tmp/icon_theme || exit 1
    ./install.sh purple
    cd ..
    rm -fR icon_theme
}

install_cursor_theme()
{
    git clone https://github.com/vinceliuice/Qogir-icon-theme.git /tmp/cursor_theme
    cd /tmp/cursor_theme || exit 1
    ./install.sh
    cd ..
    rm -fR cursor_theme
}

gnome_settings()
{
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface enable-hot-corners false

    # file history
    gsettings set org.gnome.desktop.privacy remember-recent-files true
    gsettings set org.gnome.desktop.privacy recent-files-max-age -1

    #trash and temp settings
    gsettings set org.gnome.desktop.privacy remove-old-trash-files true
    gsettings set org.gnome.desktop.privacy remove-old-temp-files true
    gsettings set org.gnome.desktop.privacy old-files-age uint32 30
}

nautilus_settings()
{
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
}

get_settings()
{
    gsettings list-recursively > /tmp/gsettings.after
    diff /tmp/gsettings.before /tmp/gsettings.after | grep -Po '> \K.*'
}