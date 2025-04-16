#!/bin/bash

current_dir=$(dirname $(realpath $0))

# update package management and install depedency 
sudo pacman -Syu && sudo pacman -S --needed --noconfirm -< $current_dir/pkg/pkglist.txt

# check if paru is already installed, if not install it
if [ -x "$(command -v paru)" ]; then
	echo "paru is already installed"
else
	# tmp dir
	tmp_dir=/tmp/paru-bin
	git clone https://aur.archlinux.org/paru-bin.git $tmp_dir
	makepkg -si -D $tmp_dir
fi

# install AUR packages
paru -S --needed --noconfirm -< $current_dir/pkg/pkglist_aur.txt
