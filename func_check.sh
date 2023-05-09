#! /usr/bin/bash

mount_points=(documents archive library ressources learning)
server_shares=(documents usb_backup library ressources learning)
server_name=fileserver
server_address=10.32.64.200
tmp_path=/tmp/
mount_dir=mnt
# TODO change dir to systemd system path
system_path=/etc/systemd/system/

# shellcheck source=mount_network_shares.sh
source mount_network_shares.sh

writecredentials "<user_name>" "<password>" ".smb"