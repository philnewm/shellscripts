#! /bin/bash

# This file contains a bunch of functions related to file permissions

set_exclusive_rw_owner()
{
    local owner=$1
    local path=$2 

    sudo chown "$owner":"$owner" "$path"
    sudo chmod 600 "$path"
}