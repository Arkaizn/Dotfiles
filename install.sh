#!/bin/bash

# Define color codes for better visibility
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# 1. Update system
echo -e "${YELLOW}Updating packages...${NC}"
sudo pacman -Syu --noconfirm

# 2. installing essential packages
# Define essential packages
essential_packages=(
    nano
    curl
    wget
    fastfetch
    hyprland
    alacritty
    hyprpaper
    hyprlock
    hyprcursor
    xdg-desktop-portal-hyprland
    ntfs-3g
    p7zip
    rofi
    thunar
    waybar
)

essential_vm_packages=(
    open-vm-tools
    mesa
    libglvnd
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
        for package in "${essential_packages[@]}"; do
            echo -e "${YELLOW}Installing $package...${NC}"
            if sudo pacman -S --noconfirm "$package"; then
                echo -e "${GREEN}$package installed successfully.${NC}"
            else
                echo -e "${RED}Failed to install $package. Skipping...${NC}"
                read
            fi
        done
        ;;
    *)
        echo -e "${YELLOW}Installation cancelled. Skipping...${NC}"
        ;;
esac

# Check if yay is installed
if command -v yay &>/dev/null; then
    echo "yay is already installed. Skipping installation."
else
    echo "yay is not installed. Proceeding with installation."

    # Install necessary dependencies
    sudo pacman -S --needed base-devel

    # Clone, build, and install yay in a subshell
    (
        git clone https://aur.archlinux.org/yay.git
        cd yay || exit 1
        makepkg -si
    )
    rm -rf yay
fi

# install browser
yay -S zen-browser-bin

# 3. install zsh
echo -e "${YELLOW}When you install Zsh, it will prompt you to start using it. If you choose to do so, you can type 'exit' in Zsh to return to your previous shell, allowing the script to continue running.${NC}"
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

# install config
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
