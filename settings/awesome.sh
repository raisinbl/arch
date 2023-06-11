#!/bin/bash

# Check if .xinitrc exists in the user's home directory
if [[ ! -f "$HOME/.xinitrc" ]]; then
  # Create .xinitrc if it doesn't exist
  echo "exec awesome" > "$HOME/.xinitrc"
else
  # Check if .xinitrc contains "exec awesome" line
  if ! grep -q "exec awesome" "$HOME/.xinitrc"; then
    # Append "exec awesome" to .xinitrc
    echo "exec awesome" >> "$HOME/.xinitrc"
  fi
fi

# Check if the Awesome directory exists
awesome_dir="$HOME/.config/awesome"
if [[ ! -d "$awesome_dir" ]]; then
  # Create the Awesome directory if it doesn't exist
  mkdir -p "$awesome_dir"
fi

# Copy rc.lua to the Awesome directory
cp "rc.lua" "$awesome_dir/rc.lua"