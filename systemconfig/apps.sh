#!/bin/bash

# packages list
aur_packages=(
    "ani-cli"
    "ferdium"
    "hyprshot"
    "iwgtk"
    "nordvpn-bin"
    "pyprland"
    "rustdesk"
    "vesktop-bin"
    "vmware-workstation"
    "vscodium-bin"
    "wlogout"
    "zen-browser-avx2-bin"    
)
pacman_packages=(
    "wine"
    "steam"
    "thunderbird"
    "pacman-contrib"
    "gnome-terminal"
)
flatpaks=(
    "com.github.tchx84.Flatseal"
    "org.gnome.Boxes"
    "sh.cider.Cider"
    "ca.desrt.dconf-editor"
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

# install flatpak manager and add flathub
sudo pacman -S flatpak --noconfirm
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


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
# modrinth appimage
(
    cd ~
    curl -L -o modrinth.AppImage "https://launcher-files.modrinth.com/versions/0.8.9/linux/Modrinth%20App_0.8.9_amd64.AppImage"
    chmod +x modrinth.AppImage
)

# setting vesktop theme
(
    git clone https://github.com/ClearVision/ClearVision-v6.git
    cd ClearVision-v6
    cp ./ClearVision_v6.theme.css ~/.config/vesktop/themes
    cd ..
    rm -fr ClearVision-v6
)