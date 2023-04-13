#! /usr/bin/bash

shares=(documents archive library ressources learning)
mount_point=mnt
server=fileserver
server_shares=(documents usb_backup library ressources learning)
fs_type=cifs
mnt_options='credentials=/home/mainws/.smb,rw,uid=1000,gid=1000,iocharset=utf8,_netdev,noserverino
DirectoryMode=0700'
idle=60

for ((i=0; i<${#shares[@]}; i++));
do
printf "[Unit]\nDescription=mount ${shares[i]} share

[Mount]\nWhat=//$server/${server_shares[i]}
Where=/$mount_point/${shares[i]}
Type=$fs_type
Options=$mnt_options

[Install]\nWantedBy=multi-user.target" > mount/$mount_point-${shares[i]}.mount

printf "[Unit]\nDescription=mount ${shares[i]} share

[Automount]\nWhere=/$mount_point/${shares[i]}
TimeoutIdle=$idle

[INSTALL]\nWantedBy=multi-user.target" > mount/$mount_point-${shares[i]}.automount
done

sudo systemctl daemon-reload

# untested
# for ((i=0; i<${#shares[@]}; i++));
# do
# sudo systemctl enable $mount_point-${shares[i]}.automount --now
# done
