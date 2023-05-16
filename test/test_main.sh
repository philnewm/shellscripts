#! /usr/bin/bash

source test_dir_utils.sh
source test_file_utils.sh

# === dir ===
test_cleanup_dir
test_root_cleanup_dir

# === file  ===
test_check_file_existence_true
test_check_file_existence_false
test_change_owner_to_user
test_change_owner_to_root