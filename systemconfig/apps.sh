#!/bin/bash

# yay installation
# Install necessary dependencies
sudo pacman -S --needed git base-devel

# Clone, build, and install yay in a subshell
(
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si
)
rm -rf yay

echo "yay installation complete!"
# aur packages

# List of AUR packages
aur_packages=(
    "vscodium-bin"
)
# Iterate over the AUR packages and install if not already installed
for pkg in "${aur_packages[@]}"; do
    if ! yay -Q "$pkg" &> /dev/null; then
        echo "Installing $pkg from AUR..."
        yay -S --needed "$pkg"
    else
        echo "$pkg is already installed. Skipping installation."
    fi
done


# pacman packages
# List of Pacman packages
pacman_packages=(
    "steam"
    "thunderbird"
)
# Iterate over the Pacman packages and install if not already installed
for pkg in "${pacman_packages[@]}"; do
    if ! pacman -Q "$pkg" &> /dev/null; then
        echo "Installing $pkg via Pacman..."
        sudo pacman -S --needed "$pkg"
    else
        echo "$pkg is already installed. Skipping installation."
    fi
done

# Flatpaks
# List of Flatpak packages
flatpaks=(
    "com.github.tchx84.Flatseal"
    "com.mattjakeman.ExtensionManager"
    "io.gitlab.zen_browser.zen"
)
# Iterate over the list and install if not already installed
for app in "${flatpaks[@]}"; do
    if ! flatpak list | grep -q "$app"; then
        echo "Installing $app..."
        flatpak install -y flathub "$app"
    else
        echo "$app is already installed. Skipping installation."
    fi
done

# Curl
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)