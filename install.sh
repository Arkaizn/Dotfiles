#!/bin/bash

# Define color codes for better visibility
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Update system
echo -e "${YELLOW}Updating packages...${NC}"
sudo pacman -Syu --noconfirm

# Define essential packages
essential_packages=(
    nano
    curl
    wget
    fastfetch
    hyprland
    sddm
    alacritty
    wlogout
    waybar
    hyprpaper
    hyprlock
    hyprcursor
    xdg-desktop-portal-hyprland
    ntfs-3g
    p7zip
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
echo -e "${YELLOW}When you install Zsh, it will prompt you to start using it. If you choose to do so, you can type 'exit' in Zsh to return to your previous shell, allowing the script to continue running.${NC}"
echo -e "${YELLOW}Do you want to install zsh and configure it? (y/n)${NC}"
read -r -p "Answer: " response
case "$response" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Installing and configuring zsh...${NC}"
        bash ./systemconfig/zshconf/zshinstall.sh
        ;;
    *)
        echo -e "${YELLOW}Skipping zsh installation.${NC}"
        ;;
esac

# Enable services
echo -e "${YELLOW}Enabling Sddm service...${NC}"
sudo systemctl enable sddm.service

# Ask for Reboot
echo -e "${GREEN}Installation complete! Hyprland is set up and running.${NC}"
echo -e "${YELLOW}Do you want to reboot? (y/n)${NC}"
    read -r -p "Answer: " response
    case "$response" in
        ""|[yY][eE][sS]|[yY])
            reboot
            ;;
        *)
            echo -e "${YELLOW}Skipping...${NC}"
            sudo systemctl start sddm.service
            ;;
    esac
