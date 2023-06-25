#!/bin/bash

# ArchRT - Arch Red Team Setup Script

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "This script must be run as a regular user, not root." 
   exit 1
fi

# Search for dotfiles directory
dotfiles_dir=$(find ~ -type d -name "dotfiles" -print -quit)

if [ -z "$dotfiles_dir" ]; then
   echo "Dotfiles directory not found. Please make sure you have the dotfiles directory in the correct location."
   exit 1
fi

# Update system
sudo pacman -Syu --noconfirm

# Install dependencies
sudo pacman -S --needed --noconfirm git base-devel cmake make yay

# Install bspwm, picom, polybar, sxhkd, dmenu
yay -S --noconfirm bspwm picom polybar sxhkd dmenu

# Set wallpaper using feh
wallpaper_path="$dotfiles_dir/Wallpapers/simple.png"
feh --bg-fill "$wallpaper_path"

# Copy dotfiles
cp -r "$dotfiles_dir/.config/bspwm" ~/.config/
cp -r "$dotfiles_dir/.config/sxhkd" ~/.config/
cp -r "$dotfiles_dir/.config/polybar" ~/.config/

# Enable launch on startup
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/polybar/launch.sh

# Add bspwm, sxhkd, polybar to Xinitrc
echo "exec bspwm" >> ~/.xinitrc
echo "sxhkd &" >> ~/.xinitrc
echo "polybar -r main &" >> ~/.xinitrc

# Configure kitty
mkdir -p ~/.config/kitty
cp "$dotfiles_dir/.config/kitty/kitty.conf" ~/.config/kitty/

# Set kitty as the default terminal
sudo update-alternatives --config x-terminal-emulator

# Configure bspwmrc
sed -i 's/urxvt/kitty/g' ~/.config/bspwm/bspwmrc

# Display completion message
echo "ArchRT setup complete. Do you want to restart your system now? (y/n)"

read -r response
if [[ $response =~ ^[Yy]$ ]]; then
    sudo systemctl reboot
fi
