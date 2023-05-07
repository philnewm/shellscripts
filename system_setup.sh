#! /usr/bin/bash

share_mounts=(documents archive library ressources learning)
server_name=fileserver
server_address=10.32.64.200

# shellcheck source=mount_network_shares.sh
source mount_network_shares.sh

# TODO change dir to systemd system path
if ! createmountpointsforuser share_mounts /mnt/Projects/tmp/mount/;
then
    cleanupdirs share_mounts /mnt/Projects/tmp/mount/
fi

addservertohosts $server_address $server_name "/etc/hosts"
