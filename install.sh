#!/bin/bash

# Define color codes for better visibility
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# 1. Update system
echo -e "${YELLOW}Updating packages...${NC}"
sudo pacman -Syu --noconfirm

# 2. installing essential packages
bash ./systemconfig/packages.sh

# 3. install zsh
echo -e "${YELLOW}Do you want to install zsh and configure it? (y/n)${NC}"
read -r -p "Answer: " response
case "$response" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Installing and configuring zsh...${NC}"
        bash ./systemconfig/zshinstall.sh
        ;;
    *)
        echo -e "${YELLOW}Skipping zsh installation.${NC}"
        ;;
esac

# install config files (.config folder)
echo -e "${YELLOW}Do you want to Copy and paste the .config files? (y/n)${NC}"
read -r -p "Answer: " response
case "$response" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Copying .config folder...${NC}"
        bash ./systemconfig/config.sh
        ;;
    *)
        echo -e "${YELLOW}Skipping .config installation.${NC}"
        ;;
esac


# set theme and icons
echo -e "${YELLOW}Do you want to set the theme and icons for GTK(inccludes cursor)? (y/n)${NC}"
read -r -p "Answer: " response
case "$response" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Setting gtk theme and icons...${NC}"
        bash ./systemconfig/theme.sh
        bash ./systemconfig/icons.sh
        ;;
    *)
        echo -e "${YELLOW}Skipping gtk theme and icons installation.${NC}"
        ;;
esac

# --------done--------
# Enable services
# echo -e "${YELLOW}Enabling Sddm service...${NC}"
# sudo systemctl enable sddm.service

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
            ;;
    esac
