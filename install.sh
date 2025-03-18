#!/bin/bash

# Farbdefinitionen
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Funktion zum Anzeigen des Hauptmenüs
show_menu() {
    echo -e "${CYAN}----------------------------------------${NC}"
    echo -e "${CYAN}      Hyprland Installationsskript${NC}"
    echo -e "${CYAN}----------------------------------------${NC}"
    echo -e "${YELLOW}1) System aktualisieren${NC}"
    echo -e "${YELLOW}2) Essenzielle Pakete installieren${NC}"
    echo -e "${YELLOW}3) Zsh installieren und konfigurieren${NC}"
    echo -e "${YELLOW}4) Konfigurationsdateien anwenden${NC}"
    echo -e "${YELLOW}5) Theme und Icons setzen${NC}"
    echo -e "${YELLOW}6) SDDM aktivieren${NC}"
    echo -e "${YELLOW}7) Alle Schritte ausführen${NC}"
    echo -e "${YELLOW}8) Beenden${NC}"
    echo -e "${CYAN}----------------------------------------${NC}"
}

# Funktion zur Benutzerabfrage
ask_user() {
    read -r -p "$1 (y/n): " response
    case "$response" in
        ""|[yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# Systemupdate
update_system() {
    echo -e "${YELLOW}System wird aktualisiert...${NC}"
    sudo pacman -Syu --noconfirm
}

# Essenzielle Pakete installieren
install_packages() {
    echo -e "${YELLOW}Installiere essenzielle Pakete...${NC}"
    bash ./systemconfig/packages.sh
}

# Zsh installieren
install_zsh() {
    if ask_user "Möchtest du Zsh installieren und konfigurieren?"; then
        echo -e "${YELLOW}Installiere und konfiguriere Zsh...${NC}"
        bash ./systemconfig/zshinstall.sh
    else
        echo -e "${YELLOW}Überspringe Zsh-Installation.${NC}"
    fi
}

# Konfigurationsdateien kopieren
apply_config() {
    echo -e "${YELLOW}Übertrage Konfigurationsdateien...${NC}"
    bash ./systemconfig/config.sh
}

# Theme und Icons setzen
set_theme_and_icons() {
    echo -e "${YELLOW}Setze Theme und Icons...${NC}"
    bash ./systemconfig/theme.sh
    bash ./systemconfig/icons.sh
}

# SDDM aktivieren
enable_sddm() {
    echo -e "${YELLOW}Aktiviere SDDM...${NC}"
    sudo systemctl enable sddm.service
}

# Hauptinstallation
run_full_install() {
    update_system
    install_packages
    install_zsh
    apply_config
    set_theme_and_icons
    enable_sddm
    echo -e "${GREEN}Installation abgeschlossen!${NC}"
}

# Menülogik
while true; do
    show_menu
    read -r -p "Bitte eine Option wählen: " choice
    case $choice in
        1) update_system ;;
        2) install_packages ;;
        3) install_zsh ;;
        4) apply_config ;;
        5) set_theme_and_icons ;;
        6) enable_sddm ;;
        7) run_full_install ;;
        8) echo -e "${GREEN}Installation beendet.${NC}"; exit 0 ;;
        *) echo -e "${YELLOW}Ungültige Auswahl. Bitte erneut versuchen.${NC}" ;;
    esac
done
