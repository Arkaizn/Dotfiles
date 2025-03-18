#!/bin/bash

# Create a temporary .dialogrc file
DIALOGRC_FILE=$(mktemp)
cat <<EOF > "$DIALOGRC_FILE"
# Enable shadows for depth effect
use_shadow = ON

# Pure Black Background
screen_color = (BLACK, BLACK, ON)

# Dialog Box Background (Dark Navy Blue)
dialog_color = (WHITE, #0A192F, ON)

# Title Bar (Bright Cyan for contrast)
title_color = (BLACK, CYAN, ON)

# Borders (Clean White for readability)
border_color = (WHITE, BLACK, ON)

# Active Button (Neon Blue Glow)
button_active_color = (BLACK, BLUE, ON)

# Inactive Button (Subtle Gray)
button_inactive_color = (WHITE, BLACK, ON)

# Progress Bar (Bright Green for modern contrast)
gauge_color = (WHITE, GREEN, ON)
EOF


# Set the environment variable to use the custom dialog colors
export DIALOGRC="$DIALOGRC_FILE"

# Farbdefinitionen
PURPLE="\033[0;35m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Array zur Verfolgung abgeschlossener Schritte
done_steps=()

# Überprüfen, ob 'dialog' installiert ist und es installieren, falls es fehlt
check_dialog_installed() {
    if ! command -v dialog &>/dev/null; then
        sudo pacman -Sy --noconfirm dialog
    fi
}


# Funktion zum Anzeigen des Hauptmenüs mit dialog
show_menu() {
    MENUCHOICE=$(dialog --title "Hyprland Installationsskript" --menu "Wählen Sie eine Option:" 15 50 8 \
        1 "System aktualisieren" \
        2 "Essenzielle Pakete installieren" \
        3 "Zsh installieren und konfigurieren" \
        4 "Konfigurationsdateien anwenden" \
        5 "Theme und Icons setzen" \
        6 "SDDM aktivieren" \
        7 "Alle verbleibenden Schritte ausführen" \
        8 "Beenden" 2>&1 >/dev/tty)

    case $MENUCHOICE in
        1) [[ ! " ${done_steps[@]} " =~ " update_system " ]] && update_system || dialog --msgbox "Bereits erledigt." 6 50 ;;
        2) [[ ! " ${done_steps[@]} " =~ " install_packages " ]] && install_packages || dialog --msgbox "Bereits erledigt." 6 50 ;;
        3) [[ ! " ${done_steps[@]} " =~ " install_zsh " ]] && install_zsh || dialog --msgbox "Bereits erledigt." 6 50 ;;
        4) [[ ! " ${done_steps[@]} " =~ " apply_config " ]] && apply_config || dialog --msgbox "Bereits erledigt." 6 50 ;;
        5) [[ ! " ${done_steps[@]} " =~ " set_theme_and_icons " ]] && set_theme_and_icons || dialog --msgbox "Bereits erledigt." 6 50 ;;
        6) [[ ! " ${done_steps[@]} " =~ " enable_sddm " ]] && enable_sddm || dialog --msgbox "Bereits erledigt." 6 50 ;;
        7) run_remaining_steps ;;
        8) dialog --msgbox "Installation beendet." 6 50; exit 0 ;;
        *) dialog --msgbox "Ungültige Auswahl. Bitte erneut versuchen." 6 50 ;;
    esac
}

# Funktion zur Benutzerabfrage mit dialog
ask_user() {
    dialog --yesno "$1" 6 50
    return $?
}

mark_done() {
    done_steps+=("$1")
}

# Systemupdate
update_system() {
    dialog --msgbox "System wird aktualisiert..." 6 50
    sudo pacman -Syu --noconfirm
    mark_done "update_system"
}

# Essenzielle Pakete installieren
install_packages() {
    dialog --msgbox "Installiere essenzielle Pakete..." 6 50
    bash ./systemconfig/packages.sh
    mark_done "install_packages"
}

# Zsh installieren
install_zsh() {
    if ask_user "Möchtest du Zsh installieren und konfigurieren?"; then
        dialog --msgbox "Installiere und konfiguriere Zsh..." 6 50
        bash ./systemconfig/zshinstall.sh
        mark_done "install_zsh"
    else
        dialog --msgbox "Überspringe Zsh-Installation." 6 50
    fi
}

# Konfigurationsdateien kopieren
apply_config() {
    dialog --msgbox "Übertrage Konfigurationsdateien..." 6 50
    bash ./systemconfig/config.sh
    mark_done "apply_config"
}

# Theme und Icons setzen
set_theme_and_icons() {
    dialog --msgbox "Setze Theme und Icons..." 6 50
    bash ./systemconfig/theme.sh
    bash ./systemconfig/icons.sh
    mark_done "set_theme_and_icons"
}

# SDDM aktivieren
enable_sddm() {
    dialog --msgbox "Aktiviere SDDM..." 6 50
    sudo systemctl enable sddm.service
    mark_done "enable_sddm"
}

# Alle verbleibenden Schritte ausführen
run_remaining_steps() {
    [[ ! " ${done_steps[@]} " =~ " update_system " ]] && update_system
    [[ ! " ${done_steps[@]} " =~ " install_packages " ]] && install_packages
    [[ ! " ${done_steps[@]} " =~ " install_zsh " ]] && install_zsh
    [[ ! " ${done_steps[@]} " =~ " apply_config " ]] && apply_config
    [[ ! " ${done_steps[@]} " =~ " set_theme_and_icons " ]] && set_theme_and_icons
    [[ ! " ${done_steps[@]} " =~ " enable_sddm " ]] && enable_sddm
    dialog --msgbox "${PURPLE}Alle Schritte abgeschlossen!" 6 50
}

cleanup() {
    rm -f "$DIALOGRC_FILE"
}

# Menülogik
check_dialog_installed
while true; do
    show_menu
done
