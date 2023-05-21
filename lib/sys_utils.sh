#! /usr/bin/bash

# This file contains a bunch of functions related to system functionality operations

disable_selinux_temporarily()
{
    sudo setenforce 0
    echo "[OK] Set se_linux to permissive temporarely"
}

enable_selinux_temporarily()
{
    sudo setenforce 1
    echo "[OK] Set se_linux to enforce temporarely"
}

# TODO change SE Linux Settings permanent
# sudo /etc/selinux/config change SELINUX=enforcing to SELINUX=permissive