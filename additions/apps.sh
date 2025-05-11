#!/bin/bash

# packages list
aur_packages=(
    "ani-cli"
    "ferdium"
    "iwgtk"
    "nordvpn-bin"
    "rustdesk"
    "vesktop-bin"
    "vmware-workstation"
    "vscodium"
    "firefox"
)
pacman_packages=(
    "wine"
    "steam"
    "thunderbird"
)

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

# Iterate over the AUR packages and install if not already installed
for pkg in "${aur_packages[@]}"; do
    if ! yay -Q "$pkg" &> /dev/null; then
        yay -S --needed "$pkg" --noconfirm --sudoloop --noanswerclean --noansweredit
    else
        echo "$pkg is already installed. Skipping installation."
    fi
done

# Iterate over the Pacman packages and install if not already installed
for pkg in "${pacman_packages[@]}"; do
    if ! pacman -Q "$pkg" &> /dev/null; then
        sudo pacman -S --needed "$pkg" --noconfirm
    else
        echo "$pkg is already installed. Skipping installation."
    fi
done

# setting vesktop theme
(
    git clone https://github.com/ClearVision/ClearVision-v6.git
    cd ClearVision-v6
    cp ./ClearVision_v6.theme.css ~/.config/vesktop/themes
    cd ..
    rm -fr ClearVision-v6
)