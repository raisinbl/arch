#!/bin/bash

# Source directory
source_directory="$HOME"

# Destination directory
destination_directory="$HOME/arch/cfg"

# List of files and folders to sync
files=(
    ".bashrc"
    ".vim"
    ".config/hypr"
    ".config/alacritty"
    ".config/waybar"
)

# Sync files and folders
for item in "${files[@]}"; do
    rsync -avz --delete "$source_directory/$item" "$destination_directory"
done

