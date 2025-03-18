#!/bin/bash

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
        dialog --msgbox "${YELLOW}Dialog wird installiert...${NC}" 6 50
        sudo pacman -S dialog --noconfirm
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
    dialog --msgbox "${YELLOW}System wird aktualisiert...${NC}" 6 50
    sudo pacman -Syu --noconfirm
    mark_done "update_system"
}

# Essenzielle Pakete installieren
install_packages() {
    dialog --msgbox "${YELLOW}Installiere essenzielle Pakete...${NC}" 6 50
    bash ./systemconfig/packages.sh
    mark_done "install_packages"
}

# Zsh installieren
install_zsh() {
    if ask_user "Möchtest du Zsh installieren und konfigurieren?"; then
        dialog --msgbox "${YELLOW}Installiere und konfiguriere Zsh...${NC}" 6 50
        bash ./systemconfig/zshinstall.sh
        mark_done "install_zsh"
    else
        dialog --msgbox "${YELLOW}Überspringe Zsh-Installation.${NC}" 6 50
    fi
}

# Konfigurationsdateien kopieren
apply_config() {
    dialog --msgbox "${YELLOW}Übertrage Konfigurationsdateien...${NC}" 6 50
    bash ./systemconfig/config.sh
    mark_done "apply_config"
}

# Theme und Icons setzen
set_theme_and_icons() {
    dialog --msgbox "${YELLOW}Setze Theme und Icons...${NC}" 6 50
    bash ./systemconfig/theme.sh
    bash ./systemconfig/icons.sh
    mark_done "set_theme_and_icons"
}

# SDDM aktivieren
enable_sddm() {
    dialog --msgbox "${YELLOW}Aktiviere SDDM...${NC}" 6 50
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
    dialog --msgbox "${PURPLE}Alle Schritte abgeschlossen!${NC}" 6 50
}

# Menülogik
check_dialog_installed
while true; do
    show_menu
done
