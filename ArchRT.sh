#!/bin/bash

# ArchRT - Arch Red Team Setup Script

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "This script must be run as a regular user, not root." 
   exit 1
fi

# Check internet connection
ping -q -w 1 -c 1 google.com &> /dev/null
if [[ $? -ne 0 ]]; then
   echo "No internet connection. Please make sure you are connected to the internet."
   exit 1
fi

# Set the current directory as the dotfiles directory
ruta=$(dirname "$0")

# Update system
sudo pacman -Syu --noconfirm

# Install dependencies
sudo pacman -S --needed --noconfirm git base-devel cmake make yay

# Install bspwm, picom, polybar, sxhkd, dmenu, rofi
yay -S --noconfirm bspwm picom polybar sxhkd dmenu rofi

# Set wallpaper using feh
wallpaper_path="$ruta/Wallpapers/simple.png"
feh --bg-fill "$wallpaper_path"

# Copy dotfiles
mkdir -p ~/.config
cp -r "$ruta/.config/bspwm" ~/.config/
cp -r "$ruta/.config/sxhkd" ~/.config/
cp -r "$ruta/.config/polybar" ~/.config/
cp -r "$ruta/.config/kitty" ~/.config/
cp -r "$ruta/.config/rofi" ~/.config/

# Enable launch on startup
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/polybar/launch.sh

# Add bspwm, sxhkd, polybar to Xinitrc
echo "exec bspwm" >> ~/.xinitrc
echo "sxhkd &" >> ~/.xinitrc
echo "polybar -r main &" >> ~/.xinitrc

# Configure kitty
sudo update-alternatives --config x-terminal-emulator
sed -i 's/urxvt/kitty/g' ~/.config/bspwm/bspwmrc

# Configure bspwmrc
sed -i 's/rofi -show/rofi -show drun/g' ~/.config/bspwm/bspwmrc

# Display completion message
echo "ArchRT setup complete. Do you want to restart your system now? (y/n)"

read -r response
if [[ $response =~ ^[Yy]$ ]]; then
    sudo systemctl reboot
fi
