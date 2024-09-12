#!/bin/bash

# Define color codes for better visibility
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Paths
DOTFILES_DIR="$HOME/git/Dotfiles"

# Update system
echo -e "${YELLOW}Updating packages...${NC}"
sudo pacman -Syu --noconfirm

# Install essential packages
echo -e "${YELLOW}Installing essential packages...${NC}"
sudo pacman -S --noconfirm nano fastfetch
bash ~/git/Dotfiles/dotfiles/zshconnf/zshinstall.sh

# GNOME installation
echo -e "${YELLOW}Installing Xorg, GNOME, and GDM...${NC}"
sudo pacman -S --noconfirm xorg xorg-server gnome gdm

# Enable GDM service
echo -e "${YELLOW}Starting and enabling GDM service...${NC}"
sudo systemctl start gdm.service
sudo systemctl enable --now gdm.service

echo -e "${GREEN}Installation complete! GNOME is set up and running.${NC}"

