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

backup_dirs=($blender_config_dir $maya_config_dir $houdini_config_dir $ocio_config_dir)

destination_maya_dir=/mnt/library/maya/
destination_maya_file=$destination_maya_dir"maya_pref"$backup_date_time

#==========>MAYA BACKUP LOGIC<==========
echo "compressing $maya_config_dir and moving file to $destination_maya_file"
cd "$maya_config_dir"
# TODO create zip file in tmp first and then upload
tar -czf $destination_maya_file .
# zip -6rq $destination_maya_file .
# TODO check if file got created at destination
