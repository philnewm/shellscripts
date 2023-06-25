#! /bin/bash

source ../lib/sys_utils.sh

test_disable_selinux_temporarily()
{
    disable_selinux_temporarily
    if getenforce -eq Permissive > /dev/null;
    then
        echo "[PASS]: ${FUNCNAME[0]}"
        return 0
    fi

    echo "[FAIL] ${FUNCNAME[0]} selinux not changed to permissive"
}