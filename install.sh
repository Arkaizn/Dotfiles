#!/bin/bash

# Create a temporary .dialogrc file
#DIALOGRC_FILE=$(mktemp)
#cat <<EOF > "$DIALOGRC_FILE"
# Enable shadow for subtle depth
#use_shadow = OFF
# Set background to black (Simple and sleek)
#screen_color = (BLACK, BLACK, ON)
# Dialog box background (Dark gray instead of gray, cleaner and less harsh)
#dialog_color = (WHITE, BLACK, ON)
# Title text color (Muted cyan for subtle contrast)
#title_color = (BLACK, CYAN, ON)
# Border (Simple white to keep it clean)
#border_color = (WHITE, BLACK, ON)
# Button Active Color (Green for pop but not too intense)
#button_active_color = (BLACK, GREEN, ON)
# Button Inactive Color (Light gray for non-interactive buttons)
#button_inactive_color = (WHITE, BLACK, ON)
# Progress Bar (Green for clean visibility)
#gauge_color = (WHITE, GREEN, ON)
#EOF

# Set the environment variable to use the custom dialog colors
#export DIALOGRC="$DIALOGRC_FILE"

# Color definitions
PURPLE="\033[0;35m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Array to track completed steps
done_steps=()

# Check if 'dialog' is installed and install it if missing
check_dialog_installed() {
    if ! command -v dialog &>/dev/null; then
        sudo pacman -Sy --noconfirm dialog
    fi
}

# Function to display the main menu using dialog
show_menu() {
    MENUCHOICE=$(dialog --title "Hyprland Installation Script" --menu "Choose an option:" 15 50 8 \
        1 "Update system" \
        2 "Install essential packages" \
        3 "Install and configure Zsh" \
        4 "Apply configuration files" \
        5 "Set theme and icons" \
        6 "Enable SDDM" \
        7 "Run all remaining steps" \
        8 "Exit" 2>&1 >/dev/tty)

    case $MENUCHOICE in
        1) [[ ! " ${done_steps[@]} " =~ " update_system " ]] && update_system || dialog --msgbox "Already completed." 6 50 ;;
        2) [[ ! " ${done_steps[@]} " =~ " install_packages " ]] && install_packages || dialog --msgbox "Already completed." 6 50 ;;
        3) [[ ! " ${done_steps[@]} " =~ " install_zsh " ]] && install_zsh || dialog --msgbox "Already completed." 6 50 ;;
        4) [[ ! " ${done_steps[@]} " =~ " apply_config " ]] && apply_config || dialog --msgbox "Already completed." 6 50 ;;
        5) [[ ! " ${done_steps[@]} " =~ " set_theme_and_icons " ]] && set_theme_and_icons || dialog --msgbox "Already completed." 6 50 ;;
        6) [[ ! " ${done_steps[@]} " =~ " enable_sddm " ]] && enable_sddm || dialog --msgbox "Already completed." 6 50 ;;
        7) run_remaining_steps ;;
        8) dialog --msgbox "Installation finished." 6 50; exit 0 ;;
        *) dialog --msgbox "Invalid selection. Please try again." 6 50 ;;
    esac
}

# Function to prompt the user with a yes/no dialog
ask_user() {
    dialog --yesno "$1" 6 50
    return $?
}

mark_done() {
    done_steps+=("$1")
}

# System update
update_system() {
    dialog --msgbox "Updating system..." 6 50
    sudo pacman -Syu --noconfirm
    mark_done "update_system"
}

# Install essential packages
install_packages() {
    dialog --msgbox "Installing essential packages..." 6 50
    bash ./scripts/packages.sh
    mark_done "install_packages"
}

# Install Zsh
install_zsh() {
    if ask_user "Do you want to install and configure Zsh?"; then
        dialog --msgbox "Installing and configuring Zsh..." 6 50
        bash ./scripts/zshinstall.sh
        mark_done "install_zsh"
    else
        dialog --msgbox "Skipping Zsh installation." 6 50
    fi
}

# Apply configuration files
apply_config() {
    dialog --msgbox "Applying configuration files..." 6 50
    bash ./scripts/config.sh
    mark_done "apply_config"
}

# Set theme and icons
set_theme_and_icons() {
    dialog --msgbox "Setting theme and icons..." 6 50
    bash ./scripts/theme.sh
    bash ./scripts/icons.sh
    mark_done "set_theme_and_icons"
}

# Enable SDDM
enable_sddm() {
    dialog --msgbox "Enabling SDDM..." 6 50
    sudo systemctl enable sddm.service
    mark_done "enable_sddm"
}

# Run all remaining steps
run_remaining_steps() {
    [[ ! " ${done_steps[@]} " =~ " update_system " ]] && update_system
    [[ ! " ${done_steps[@]} " =~ " install_packages " ]] && install_packages
    [[ ! " ${done_steps[@]} " =~ " install_zsh " ]] && install_zsh
    [[ ! " ${done_steps[@]} " =~ " apply_config " ]] && apply_config
    [[ ! " ${done_steps[@]} " =~ " set_theme_and_icons " ]] && set_theme_and_icons
    [[ ! " ${done_steps[@]} " =~ " enable_sddm " ]] && enable_sddm
    dialog --msgbox "${PURPLE}All steps completed!" 6 50
}

cleanup() {
    rm -f "$DIALOGRC_FILE"
}

# Menu logic
check_dialog_installed
while true; do
    show_menu
done
