#! /bin/bash

install_tweaks()
{
    sudo dnf install gnome-tweaks
}

enable_dark_mode()
{
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
}

window_config()
{
    org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
    org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'
    org.gnome.mutter attach-modal-dialogs false
}

disable_extension_popup()
{
    org.gnome.tweaks show-extensions-notice false
}

disable_hot_corner()
{
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