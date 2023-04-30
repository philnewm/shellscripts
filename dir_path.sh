#!/bin/bash
echo "Please enter the first letters of the directory name:"
read dir_letters
blender_config_dir=$(ls -d ~/Apps/blender_versions/stable/blender-$dir_letters*/)
echo "The Blender configuration directory is: $blender_config_dir"