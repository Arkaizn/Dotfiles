#!/bin/bash

# Farbdefinitionen
PURPLE="\033[0;35m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
WHITE="\033[1;37m"
NC="\033[0m" # No Color

# Array zur Verfolgung abgeschlossener Schritte
done_steps=()

# Überprüfen, ob 'whiptail' installiert ist und es installieren, falls es fehlt
check_whiptail_installed() {
    if ! command -v whiptail &>/dev/null; then
        sudo pacman -Sy --noconfirm newt
    fi
}

# Funktion zum Anzeigen des Hauptmenüs mit whiptail
show_menu() {
    MENUCHOICE=$(whiptail --title "Hyprland Installationsskript" --menu "Wählen Sie eine Option:" 15 50 8 \
        1 "System aktualisieren" \
        2 "Essenzielle Pakete installieren" \
        3 "Zsh installieren und konfigurieren" \
        4 "Konfigurationsdateien anwenden" \
        5 "Theme und Icons setzen" \
        6 "SDDM aktivieren" \
        7 "Alle verbleibenden Schritte ausführen" \
        8 "Beenden" 3>&1 1>&2 2>&3)

    case $MENUCHOICE in
        1) [[ ! " ${done_steps[@]} " =~ " update_system " ]] && update_system || whiptail --msgbox "Bereits erledigt." 6 50 ;;
        2) [[ ! " ${done_steps[@]} " =~ " install_packages " ]] && install_packages || whiptail --msgbox "Bereits erledigt." 6 50 ;;
        3) [[ ! " ${done_steps[@]} " =~ " install_zsh " ]] && install_zsh || whiptail --msgbox "Bereits erledigt." 6 50 ;;
        4) [[ ! " ${done_steps[@]} " =~ " apply_config " ]] && apply_config || whiptail --msgbox "Bereits erledigt." 6 50 ;;
        5) [[ ! " ${done_steps[@]} " =~ " set_theme_and_icons " ]] && set_theme_and_icons || whiptail --msgbox "Bereits erledigt." 6 50 ;;
        6) [[ ! " ${done_steps[@]} " =~ " enable_sddm " ]] && enable_sddm || whiptail --msgbox "Bereits erledigt." 6 50 ;;
        7) run_remaining_steps ;;
        8) whiptail --msgbox "Installation beendet." 6 50; exit 0 ;;
        *) whiptail --msgbox "Ungültige Auswahl. Bitte erneut versuchen." 6 50 ;;
    esac
}

# Funktion zur Benutzerabfrage mit whiptail
ask_user() {
    whiptail --yesno "$1" 6 50
    return $?
}

mark_done() {
    done_steps+=("$1")
}

# Systemupdate
update_system() {
    whiptail --msgbox "System wird aktualisiert..." 6 50
    sudo pacman -Syu --noconfirm
    mark_done "update_system"
}

# Essenzielle Pakete installieren
install_packages() {
    whiptail --msgbox "Installiere essenzielle Pakete..." 6 50
    bash ./systemconfig/packages.sh
    mark_done "install_packages"
}

# Zsh installieren
install_zsh() {
    if ask_user "Möchtest du Zsh installieren und konfigurieren?"; then
        whiptail --msgbox "Installiere und konfiguriere Zsh..." 6 50
        bash ./systemconfig/zshinstall.sh
        mark_done "install_zsh"
    else
        whiptail --msgbox "Überspringe Zsh-Installation." 6 50
    fi
}

# Konfigurationsdateien kopieren
apply_config() {
    whiptail --msgbox "Übertrage Konfigurationsdateien..." 6 50
    bash ./systemconfig/config.sh
    mark_done "apply_config"
}

# Theme und Icons setzen
set_theme_and_icons() {
    whiptail --msgbox "Setze Theme und Icons..." 6 50
    bash ./systemconfig/theme.sh
    bash ./systemconfig/icons.sh
    mark_done "set_theme_and_icons"
}

# SDDM aktivieren
enable_sddm() {
    whiptail --msgbox "Aktiviere SDDM..." 6 50
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
    whiptail --msgbox "${PURPLE}Alle Schritte abgeschlossen!" 6 50
}

cleanup() {
    rm -f "$DIALOGRC_FILE"
}

# Menülogik
check_whiptail_installed
while true; do
    show_menu
done
