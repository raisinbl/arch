#! /bin/bash

script_dir=$(dirname "$(realpath $0)")

pacman -Qqen > $script_dir/pkglist.txt
pacman -Qqem > $script_dir/pkglist_aur.txt
