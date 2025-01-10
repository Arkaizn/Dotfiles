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
    "pywal-git"  
)
pacman_packages=(
    "wine"
    "steam"
    "thunderbird"
    "pacman-contrib"
    "gnome-terminal"
    "swaylock"
    "swaync"
)
flatpaks=(
    "com.github.tchx84.Flatseal"
    "org.gnome.Boxes"
    "sh.cider.Cider"
    "ca.desrt.dconf-editor"
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

# install flatpak manager and add flathub
sudo pacman -S flatpak --noconfirm
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# Iterate over the list and install if not already installed
for app in "${flatpaks[@]}"; do
    if ! flatpak list | grep -q "$app"; then
        flatpak install -y flathub "$app" -y
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