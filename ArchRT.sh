#!/bin/bash

echo "********************************************************************"
echo "*                    Arch RedTeam - Setup Script                   *"
echo "********************************************************************"
echo "*     ______                       __         _______  ________    *"
echo "*    /      \                     |  \       |       \|        \   *"
echo "*   |  $$$$$$\  ______    _______ | $$____   | $$$$$$$\\$$$$$$$$   *"
echo "*   | $$__| $$ /      \  /       \| $$    \  | $$__| $$  | $$      *"
echo "*   | $$    $$|  $$$$$$\|  $$$$$$$| $$$$$$$\ | $$    $$  | $$      *"
echo "*   | $$$$$$$$| $$   \$$| $$      | $$  | $$ | $$$$$$$\  | $$      *"
echo "*   | $$  | $$| $$      | $$_____ | $$  | $$ | $$  | $$  | $$      *"
echo "*   | $$  | $$| $$       \$$     \| $$  | $$ | $$  | $$  | $$      *"
echo "*    \$$   \$$ \$$        \$$$$$$$ \$$   \$$  \$$   \$$   \$$      *"
echo "********************************************************************"
echo "*                         Made by g0nchy                           *"
echo "********************************************************************"

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

# INSTALLING GREETER (LIGHTDM)

# Install lightdm and lightdm-gtk-greeter
sudo pacman -S --noconfirm lightdm lightdm-gtk-greeter

# Add lightdm and greeter to config file
echo "greeter-session=lightdm-gtk-greeter" | sudo tee -a /etc/lightdm/lightdm.conf

# Install systemd. Enable lightdm service
sudo pacman -S --noconfirm systemd
sudo systemctl enable lightdm.service

# INSTALLING BSPWM, SXHKD, DMENU, PICOM, KITTY AND FEH

# Install bspwm, sxhkd, dmenu, picom, kitty and feh
sudo pacman -S --noconfirm bspwm sxhkd dmenu picom kitty feh

# Add commands to .xprofile for sxhkd and bspwm
echo "sxhkd &" | sudo tee -a ~/.xprofile # Start sxhkd in the background
echo "exec bspwm" | sudo tee -a ~/.xprofile # Execute bspwm as the (tiling) window manager

# Create directories to store bspwm and sxhkd configuration files
mkdir ~/.config/bspwm
mkdir ~/.config/sxhkd

# Copy configurations files for bspwm and sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/

# Configute kitty as the terminal emulator in the sxhkd
sed -i 's/urxvt/kitty/' ~/.config/sxhkd/sxhkdrc

# Display completion message
echo "ArchRT setup complete. Do you want to restart your system now? (y/n)"

read -r response
if [[ $response =~ ^[Yy]$ ]]; then
    sudo systemctl reboot
fi
