#! bin/bash

# update package management and install depedency 
sudo pacman -Syu && sudo pacman -S --needed -< pkg/pm 

# install AUR helper
git clone https://aur.archlinux.org/paru.git
cd paru & makepkg -is
cd ..

export wm=hyprland
# install windows manager
sudo pacman -S --needed -< wm/$wm/pm
paru -S --needed -< vm/$wm/aur

# config
rsync -r cfg/ $HOME
