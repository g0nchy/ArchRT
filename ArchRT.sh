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

#!/bin/bash

# Update system
sudo pacman -Syu --noconfirm

# Installl bspwm, sxhkd y dmenu
sudo pacman -S --noconfirm bspwm sxhkd dmenu

# Configurate bspwmrc
echo "exec bspwm" > ~/.config/bspwm/bspwmrc

# Configurate sxhkdrc
echo "super + Return" >> ~/.config/sxhkd/sxhkdrc
echo "    kitty &" >> ~/.config/sxhkd/sxhkdrc

# Configurate dmenu
echo "#!/bin/bash" > ~/.dmenurc
echo "dmenu_run" >> ~/.dmenurc

# Giving execute permission
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.dmenurc

echo "Instalation and configuration of bspwm, sxhkd and dmenu completed."

# Display completion message
echo "ArchRT setup complete. Do you want to restart your system now? (y/n)"

read -r response
if [[ $response =~ ^[Yy]$ ]]; then
    sudo systemctl reboot
fi
