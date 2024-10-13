#!/bin/bash

# Define color codes for better visibility
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Install Zsh
echo -e "${YELLOW}Installing zsh...${NC}"
sudo pacman -S --noconfirm zsh

# Change default shell to Zsh
echo -e "${YELLOW}Setting zsh as the default shell...${NC}"
chsh -s $(which zsh)

# Install Oh My Zsh
echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh plugins
echo -e "${YELLOW}Installing Zsh plugins...${NC}"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Copy Dotfiles (assuming .zshrc is in the same directory as the script)
echo -e "${YELLOW}Copying .zshrc to home directory...${NC}"
cp .dotfiles/zshconf/.zshrc ~/

# Inform the user to open a new terminal
echo -e "${GREEN}Zsh is now installed and configured!${NC}"
echo -e "${GREEN}Please open a new terminal or log out and log back in to start using Zsh.${NC}"
