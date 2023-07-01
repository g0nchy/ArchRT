#!/bin/bash

# Installing feh
sudo pacman -S --noconfirm feh

echo "Installing feh"

# Set wallpaper with feh
feh --bg-fill "$HOME/Wallpapers/simple.png"

echo "Configuring wallpaper."

# Add wallpaper to .xprofile
echo '~/.fehbg &' | tee -a ~/.xprofile

echo "Wallpaper configured."
