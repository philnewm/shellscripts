#! /bin/bash

install_ui_tools()
{
    sudo dnf install gnome-tweaks -y
    sudo dnf install ulauncher -y
    sudo dnf install gnome-extensions-app -y
}

tweaks_settings()
{
    org.gnome.mutter attach-modal-dialogs false
    
    # fonts
    org.gnome.desktop.interface document-font-name 'Cantarell 11'
    org.gnome.desktop.interface font-name 'Cantarell Bold 11'
    org.gnome.desktop.interface monospace-font-name 'Source Code Pro 10'
    org.gnome.desktop.wm.preferences titlebar-font 'Carlito Bold Italic 11'
    
    # windows
    org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
    org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'

    # theme
    sudo dnf install gtk-murrine-engine -y
    sudo dnf install sassc -y
    git https://github.com/vinceliuice/Lavanda-gtk-theme.git /tmp/theme/
    cd /tmp/theme || exit 1
    ./install.sh

}

disable_extension_popup()
{
    org.gnome.tweaks show-extensions-notice false
}

gnome_settings()
{
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    org.gnome.desktop.interface enable-hot-corners false
}

nautilus_settings()
{
    org.gnome.nautilus.preferences default-folder-viewer 'list-view'
}

get_settings()
{
    gsettings list-recursively > /tmp/gsettings.after
    diff /tmp/gsettings.before /tmp/gsettings.after | grep -Po '> \K.*'
}