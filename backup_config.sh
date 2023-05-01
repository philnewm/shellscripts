#! /usr/bin/bash
# TODO add environment varibales for all config paths

#==========>BLENDER<==========
# TODO exclude default addons from backup
# TODO save one config per version
blender_conf_base=~/Apps/blender_versions/stable/
blender_ver=blender-3.0.1
blender_config_dir=$(ls -d $blender_conf_base$blender_ver*)
echo "blender config path: $blender_config_dir"

#==========>MAYA<==========
# TODO save one config per version
maya_config_base=~/maya/
maya_ver=2022
maya_config_dir=$maya_config_base$maya_ver/
echo "maya config path: $maya_config_dir"

#==========>HOUDINI<==========
# TODO save one config per version
houdini_config_base=~/houdini
houdini_ver=19.0
houdini_config_dir=$houdini_config_base$houdini_ver/
echo "houdini config path: $houdini_config_dir"

#==========>DAVINCI RESOLVE<==========
# TODO save one config per version

#==========>OCIO<==========
# TODO save one config per version
# TODO get dir from evironment varibale
ocio_config_base=/mnt/Projects/OpenColorIO/
ocio_ver=aces_1.2
ocio_config_dir=$ocio_config_base$ocio_ver/
echo "ocio config path: $ocio_config_dir"

#==========>SYSTEM DATA<==========
backup_date_time=_$(date +%d_%m_%y_%H_%M)
file_ending=.zip
tmp_loc=/tmp/

# backup_dirs=("$blender_config_dir" "$maya_config_dir" "$houdini_config_dir" "$ocio_config_dir")

destination_maya_dir=/mnt/library/maya/
maya_backup_file_name="maya_pref"$backup_date_time$file_ending
maya_backup_tmp=$tmp_loc$maya_backup_file_name
destination_maya_file=$destination_maya_dir$maya_backup_file_name

#==========>MAYA CONFIG BACKUP LOGIC<==========
if [ -d "$maya_config_dir" ]; then
    cd "$maya_config_dir" || exit 1
    echo "found \"$maya_config_dir\" compressing ..."
    tar -czf "$maya_backup_tmp" .
    if [ -f "$maya_backup_tmp" ]; then
        echo "\"$maya_backup_tmp\" backup succeeded"

        # TODO change mv to scp to work independent from smb shares
        mv "$maya_backup_tmp" "$destination_maya_file"
        if [ -f "$destination_maya_file" ]; then
            echo "config transfer to \"$destination_maya_file\" successfull"
            exit 0
        else
            echo "config transfer to \"$destination_maya_file\" failed"
            rm "$maya_backup_tmp"
            echo "removed tmp file  \"maya_backup_tmp\""
            exit 1
        fi
    fi
    exit 0
fi
echo "$maya_config_dir doesn't exist"