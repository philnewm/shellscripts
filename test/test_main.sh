#! /bin/bash

source test_dir_utils.sh
source test_file_utils.sh
source test_network_utils.sh
source test_permission_utils.sh
source test_sys_utils.sh

# === dir ===
test_cleanup_dir
test_root_cleanup_dir
test_create_dir_as_root

# === file  ===
test_check_file_existence_true
test_check_file_existence_false
test_check_string_in_file
test_append_string_to_file
test_append_string_to_file_as_root

# === network ===
test_write_systemd_mount_file
test_write_systemd_auto_mount_file

# === permissions ===
test_set_exclusive_owner
test_change_owner_to_user
test_change_owner_to_root

# == sys ===
test_disable_selinux_temporarily
