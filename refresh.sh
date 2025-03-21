#!/bin/bash

# Color definitions
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Backup target directory (Change this if needed)
BACKUP_DIR="$HOME/Backups"

# Array to track completed steps
done_steps=()

# Function to check if a step has already been completed
is_done() {
    [[ " ${done_steps[*]} " =~ " $1 " ]]
}

# Show menu using wofi
show_menu() {
    choice=$(echo -e "1) Update system\n2) Apply configuration files\n3) Set theme and icons\n4) Backup important files\n5) Exit" | wofi --dmenu -n --width 600 --height 400 --lines 10 --prompt "Choose an option:" 2>/dev/null | cut -d')' -f1 | tr -d ' ')
    
    case "$choice" in
        1) is_done update_system || update_system ;;
        2) is_done apply_config || apply_config ;;
        3) is_done set_theme_and_icons || set_theme_and_icons ;;
        4) is_done backup_files || backup_files ;;
        5) echo -e "${GREEN}Installation completed.${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid selection. Please try again.${NC}" ;;
    esac
    if [[ -z "$choice" ]]; then
        echo "Cancelled via ESC or empty input."
        exit 0
    fi
}

# Mark a step as completed
mark_done() {
    done_steps+=("$1")
}

# Perform system update
update_system() {
    echo -e "${YELLOW}Updating system...${NC}"
    if sudo pacman -Syu --noconfirm; then
        mark_done update_system
    else
        echo -e "${RED}Error updating system!${NC}"
    fi
}

# Apply configuration files
apply_config() {
    echo -e "${YELLOW}Transferring configuration files...${NC}"
    if bash ./scripts/config.sh; then
        mark_done apply_config
    else
        echo -e "${RED}Error applying configuration!${NC}"
    fi
}

# Set theme and icons
set_theme_and_icons() {
    echo -e "${YELLOW}Setting theme and icons...${NC}"
    if bash ./scripts/theme.sh && bash ./scripts/icons.sh; then
        mark_done set_theme_and_icons
    else
        echo -e "${RED}Error setting theme and icons!${NC}"
    fi
}

# Backup important files and folders
backup_files() {
    echo -e "${YELLOW}Creating backup...${NC}"

    # Ensure the backup directory exists
    mkdir -p "$BACKUP_DIR"

    # List of important files/folders (Modify as needed)
    IMPORTANT_FILES=(
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.config"
        "$HOME/Documents"
        "$HOME/Pictures"
    )

    for item in "${IMPORTANT_FILES[@]}"; do
        if [ -e "$item" ]; then
            rsync -a --progress "$item" "$BACKUP_DIR"
            echo -e "${CYAN}Backed up: $item${NC}"
        else
            echo -e "${RED}Skipped (not found): $item${NC}"
        fi
    done

    echo -e "${GREEN}Backup completed!${NC}"
    mark_done backup_files
}

# Show the main menu in a loop
while true; do
    show_menu || break
done
