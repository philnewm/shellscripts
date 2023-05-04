#! /usr/bin/bash

share_mounts=(documents archive library ressources learning)
server_shares=(documents usb_backup library ressources learning)
mount_point=mnt
server=fileserver
fs_type=cifs
mnt_options='credentials=/home/mainws/.smb,rw,uid=1000,gid=1000,iocharset=utf8,_netdev,noserverino
DirectoryMode=0700'
idle=60
tmp_path=/tmp/
main_path=/mnt/Projects/tmp/mount/ #/mnt/Projects/tmp/mount/

# TODO move into function
for ((i=0; i<${#share_mounts[@]}; i++));
do
    mount_content=$(printf "[Unit]\nDescription=mount %s share\n\n" "${share_mounts[i]}")

    mount_content=$(printf "%s\n\n[Mount]\nWhat=//%s/%s}\n\n" "$mount_content" "$server" "${server_shares[i]}")
    mount_content=$(printf "%s\nWhere=/%s/%s\n" "$mount_content" "$mount_point" "${share_mounts[i]}")
    mount_content=$(printf "%s\nType=%s\n" "$mount_content" "$fs_type")
    mount_content=$(printf "%s\nOptions=%s\n" "$mount_content" "$mnt_options")

    mount_content=$(printf "%s\n\n[Install]\n" "$mount_content")
    mount_content=$(printf "%s\nWantedBy=multi-user.target" "$mount_content") 
    
    mount_file="$tmp_path""$mount_point"-"${share_mounts[i]}"".mount"

    echo "$mount_content" > "$mount_file"

    auto_mount_content=$(printf "[Unit]\nDescription=mount %s share\n" "${share_mounts[i]}")
    auto_mount_content=$(printf "%s\n\n[Automount]\nWhere=/%s/%s\n" "$auto_mount_content" "$mount_point" "${share_mounts[i]}")
    auto_mount_content=$(printf "%s\nTimeoutIdleSec=%s\n\n" "$auto_mount_content" "$idle")
    auto_mount_content=$(printf "%s\n\n[INSTALL]\nWantedBy=multi-user.target" "$auto_mount_content")

    auto_mount_file="$tmp_path""$mount_point"-"${share_mounts[i]}"".automount"

    echo "$auto_mount_content" > "$auto_mount_file"
done

# TODO move into function
# TODO create cleanup function
# move scripts from /tmp/ to /etc/systemd/system
for ((i=0; i<${#share_mounts[@]}; i++));
do
    sudo mv "$tmp_path""$mount_point"-"${share_mounts[i]}"".mount" "$main_path""$mount_point"-"${share_mounts[i]}"".mount"
    sudo mv "$tmp_path""$mount_point"-"${share_mounts[i]}"".automount" "$main_path""$mount_point"-"${share_mounts[i]}"".automount"
done

# TODO move into function
# TODO create cleanup function
# TODO change permission after creation
cd /tmp || exit
for ((i=0; i<${#share_mounts[@]}; i++));
do
    sudo mkdir "${share_mounts[i]}"
done

# sudo systemctl daemon-reload

# for ((i=0; i<${#share_mounts[@]}; i++));
# do
# sudo systemctl enable "$mount_point"-"${share_mounts[i]}".automount --now
# done
