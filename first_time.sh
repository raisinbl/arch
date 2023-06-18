#!/bin/bash

# update package management and install depedency 
sudo pacman -Syu && sudo pacman -S --needed -< pkg/pm 

# install AUR helper
git clone https://aur.archlinux.org/paru-bin.git
makepkg -is paru-bin/

export wm=hyprland
# install windows manager
sudo pacman -S --needed -< wm/$wm/pm
paru -S --needed -< wm/$wm/aur

# config
rsync -r cfg/ $HOME
