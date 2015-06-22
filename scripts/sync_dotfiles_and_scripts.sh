#!/bin/bash

set -e

DOTFILES_TARGET_DIR=~
SCRIPTS_TARGET_DIR=~/scripts

this_script=`readlink -f "$0"`
scripts_src_dir=`dirname "$this_script"`
dotfile_src_dir=`readlink -f "$scripts_src_dir/../dotfiles"`

echo "syncing ${dotfile_src_dir}/ to ${DOTFILES_TARGET_DIR}/"
rsync -rt "${dotfile_src_dir}/" "${DOTFILES_TARGET_DIR}/"

echo "syncing ${scripts_src_dir}/ to ${SCRIPTS_TARGET_DIR}/"
rsync -rt "${scripts_src_dir}/" "${SCRIPTS_TARGET_DIR}/"

# remove this script from ~/scripts so I don't accidentally execute it
this_script_file_name=`basename ${this_script}`
rm "${SCRIPTS_TARGET_DIR}/$this_script_file_name"
