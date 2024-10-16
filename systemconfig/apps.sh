#!/bin/bash

# packages list
aur_packages=(
    "vscodium-bin"
    "nordvpn-bin"
    "modrinth-app"
    "vesktop-bin"
)
pacman_packages=(
    "steam"
    "thunderbird"
    "pacman-contrib"
    "gnome-terminal"
)
flatpaks=(
    "com.github.tchx84.Flatseal"
    "com.mattjakeman.ExtensionManager"
    "io.github.zen_browser.zen"
)


# yay installation
# Install necessary dependencies
sudo pacman -S --needed base-devel
# Clone, build, and install yay in a subshell
(
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si
)
rm -rf yay

# Iterate over the AUR packages and install if not already installed
for pkg in "${aur_packages[@]}"; do
    if ! yay -Q "$pkg" &> /dev/null; then
        echo "Installing $pkg from AUR..."
        yay -S --needed "$pkg"
    else
        echo "$pkg is already installed. Skipping installation."
    fi
done

# Iterate over the Pacman packages and install if not already installed
for pkg in "${pacman_packages[@]}"; do
    if ! pacman -Q "$pkg" &> /dev/null; then
        echo "Installing $pkg via Pacman..."
        sudo pacman -S --needed "$pkg"
    else
        echo "$pkg is already installed. Skipping installation."
    fi
done

# Iterate over the list and install if not already installed
for app in "${flatpaks[@]}"; do
    if ! flatpak list | grep -q "$app"; then
        echo "Installing $app..."
        flatpak install -y flathub "$app"
    else
        echo "$app is already installed. Skipping installation."
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