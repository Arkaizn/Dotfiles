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
bash ./systemconfig/config.sh

# Ask if vmware
echo -e "${YELLOW}Are you in a Vmware Virtual Machine? (y/n)${NC}"
read -r -p "Answer: " proceed
case "$proceed" in
    ""|[yY][eE][sS]|[yY])
        echo -e "${YELLOW}Installing essential packages for vmware...${NC}"
        for vm_package in "${essential_vm_packages[@]}"; do
            echo -e "${YELLOW}Installing $vm_package...${NC}"
            if sudo yay -S --noconfirm --noanswerclean --noansweredit "$vm_package"; then
                echo -e "${GREEN}$vm_package installed successfully.${NC}"
            else
                echo -e "${RED}Failed to install $vm_package. Skipping...${NC}"
                read
            fi
        done
        sudo systemctl enable --now vmtoolsd.service # enable service
        ;;
    *)
        echo -e "${YELLOW}Installation cancelled. Skipping...${NC}"
        ;;
esac

# set theme and icons
bash ./systemconfig/theme.sh
bash ./systemconfig/icons.sh

# done
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
            ;;
    esac
