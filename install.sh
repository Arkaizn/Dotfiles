#!/bin/bash

# Define color codes for better visibility
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Paths
DOTFILES_DIR="$HOME/git/Dotfiles"

# Functions
ask_install_zsh() {
    echo -e "${YELLOW}Do you want to install zsh and configure it? (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            echo -e "${YELLOW}Installing and configuring zsh...${NC}"
            bash ./dotfiles/zshconnf/zshinstall.sh
            ;;
        *)
            echo -e "${YELLOW}Skipping zsh installation.${NC}"
            ;;
    esac
}

# Update system
echo -e "${YELLOW}Updating packages...${NC}"
sudo pacman -Syu --noconfirm

# Define essential packages
essential_packages=(
    nano
    fastfetch
    xorg
    xorg-server
    gnome
    gdm
)

# Show packages that will be installed
echo -e "${YELLOW}The following packages will be installed:${NC}"
for package in "${essential_packages[@]}"; do
    echo -e "${GREEN}- $package${NC}"
done

# Confirm package installation
echo -e "${YELLOW}Proceed with the installation? (y/n)${NC}"
read -r -p "Answer: " proceed
case "$proceed" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Installing essential packages...${NC}"
        sudo pacman -S --noconfirm "${essential_packages[@]}"
        ;;
    *)
        echo -e "${YELLOW}Installation cancelled. Skipping...${NC}"
        ;;
esac

# Ask if user wants to install zsh
ask_install_zsh

# Enable services
echo -e "${YELLOW}Enabling GDM service...${NC}"
sudo systemctl enable --now gdm.service

echo -e "${GREEN}Installation complete! GNOME is set up and running.${NC}"
reboot
