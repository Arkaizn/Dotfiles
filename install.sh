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
sudo pacman -S --noconfirm nano zsh oh-my-zsh fastfetch

# GNOME installation
echo -e "${YELLOW}Installing Xorg, GNOME, and GDM...${NC}"
sudo pacman -S --noconfirm xorg xorg-server gnome gdm

# Install Zsh
echo -e "${YELLOW}Installing zsh...${NC}"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Enable GDM service
echo -e "${YELLOW}Starting and enabling GDM service...${NC}"
sudo systemctl start gdm.service
sudo systemctl enable --now gdm.service

echo -e "${GREEN}Installation complete! GNOME is set up and running.${NC}"

# Copy Dotfiles
cp ~/git/Dotfiles/dotfiles/.zshrc ~/

# Source Zsh config
source ~/.zshrc
