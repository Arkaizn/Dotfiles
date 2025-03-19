#!/bin/bash

# Farbdefinitionen
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Array zur Verfolgung abgeschlossener Schritte
done_steps=()

# Funktion zum Anzeigen des Hauptmenüs mit wofi
show_menu() {
    choice=$(echo -e "1) System aktualisieren\n2) Essenzielle Pakete installieren\n3) Zsh installieren und konfigurieren\n4) Konfigurationsdateien anwenden\n5) Theme und Icons setzen\n6) SDDM aktivieren\n7) Alle verbleibenden Schritte ausführen\n8) Beenden" | wofi --dmenu --width 400 --height 300 --prompt "Wähle eine Option:")
    
    case "$choice" in
        1) [[ ! " ${done_steps[@]} " =~ " update_system " ]] && update_system || echo -e "${YELLOW}Bereits erledigt.${NC}" ;;
        2) [[ ! " ${done_steps[@]} " =~ " install_packages " ]] && install_packages || echo -e "${YELLOW}Bereits erledigt.${NC}" ;;
        3) [[ ! " ${done_steps[@]} " =~ " install_zsh " ]] && install_zsh || echo -e "${YELLOW}Bereits erledigt.${NC}" ;;
        4) [[ ! " ${done_steps[@]} " =~ " apply_config " ]] && apply_config || echo -e "${YELLOW}Bereits erledigt.${NC}" ;;
        5) [[ ! " ${done_steps[@]} " =~ " set_theme_and_icons " ]] && set_theme_and_icons || echo -e "${YELLOW}Bereits erledigt.${NC}" ;;
        6) [[ ! " ${done_steps[@]} " =~ " enable_sddm " ]] && enable_sddm || echo -e "${YELLOW}Bereits erledigt.${NC}" ;;
        7) run_remaining_steps ;;
        8) echo -e "${GREEN}Installation beendet.${NC}"; exit 0 ;;
        *) echo -e "${YELLOW}Ungültige Auswahl. Bitte erneut versuchen.${NC}" ;;
    esac
}

# Funktion zur Benutzerabfrage mit wofi
ask_user() {
    response=$(echo -e "Ja\nNein" | wofi --dmenu --width 400 --height 100 --prompt "$1")
    if [ "$response" == "Ja" ]; then
        return 0
    else
        return 1
    fi
}

mark_done() {
    done_steps+=("$1")
}

# Systemupdate
update_system() {
    echo -e "${YELLOW}System wird aktualisiert...${NC}"
    sudo pacman -Syu --noconfirm
    mark_done "update_system"
}

# Essenzielle Pakete installieren
install_packages() {
    echo -e "${YELLOW}Installiere essenzielle Pakete...${NC}"
    bash ./systemconfig/packages.sh
    mark_done "install_packages"
}

# Zsh installieren
install_zsh() {
    if ask_user "Möchtest du Zsh installieren und konfigurieren?"; then
        echo -e "${YELLOW}Installiere und konfiguriere Zsh...${NC}"
        bash ./systemconfig/zshinstall.sh
        mark_done "install_zsh"
    else
        echo -e "${YELLOW}Überspringe Zsh-Installation.${NC}"
    fi
}

# Konfigurationsdateien kopieren
apply_config() {
    echo -e "${YELLOW}Übertrage Konfigurationsdateien...${NC}"
    bash ./systemconfig/config.sh
    mark_done "apply_config"
}

# Theme und Icons setzen
set_theme_and_icons() {
    echo -e "${YELLOW}Setze Theme und Icons...${NC}"
    bash ./systemconfig/theme.sh
    bash ./systemconfig/icons.sh
    mark_done "set_theme_and_icons"
}

# SDDM aktivieren
enable_sddm() {
    echo -e "${YELLOW}Aktiviere SDDM...${NC}"
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
    echo -e "${GREEN}Alle Schritte abgeschlossen!${NC}"
}

# Menülogik
while true; do
    show_menu
done
