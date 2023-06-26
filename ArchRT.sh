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

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Update system
sudo pacman -Syu --noconfirm

# Install bspwm, sxhkd, dmenu, and kitty
sudo pacman -S --noconfirm bspwm sxhkd dmenu kitty

# Configure bspwm
echo "exec bspwm" > ~/.config/bspwm/bspwmrc

# Configure sxhkd
echo "super + Return" >> ~/.config/sxhkd/sxhkdrc
echo "    kitty" >> ~/.config/sxhkd/sxhkdrc

# Configure dmenu
echo "#!/bin/bash" > ~/.dmenurc
echo "dmenu_run" >> ~/.dmenurc

# Giving execute permission
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.dmenurc

# Copy dotfiles to respective directories
cp -r "$ruta/dotfiles/.config/kitty" ~/.config/
cp -r "$ruta/dotfiles/.config/picom" ~/.config/
cp -r "$ruta/dotfiles/.config/polybar" ~/.config/

echo "Installation and configuration of bspwm, sxhkd, dmenu, and kitty completed."

# Display completion message
echo "ArchRT setup complete. Do you want to restart your system now? (y/n)"

read -r response
if [[ $response =~ ^[Yy]$ ]]; then
    sudo systemctl reboot
fi
