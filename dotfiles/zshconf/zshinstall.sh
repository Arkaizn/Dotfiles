#!/bin/bash

# Define color codes for better visibility
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# install Zsh
echo -e "${YELLOW}Installing zsh...${NC}"
sudo pacman -S zsh

# Install Zsh config
echo -e "${YELLOW}Installing zsh config...${NC}"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Copy Dotfiles
cp ~/git/Dotfiles/dotfiles/.zshrc ~/

# Source Zsh config
source ~/.zshrc
