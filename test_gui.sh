#!/bin/bash

# Farbdefinitionen
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Array zur Verfolgung abgeschlossener Schritte
done_steps=()

# Funktion zum Anzeigen des Hauptmenüs
show_menu() {
    OPTION=$(zenity --list --title="Hyprland Installationsskript" --column="Optionen" \
        "1) System aktualisieren" \
        "2) Essenzielle Pakete installieren" \
        "3) Zsh installieren und konfigurieren" \
        "4) Konfigurationsdateien anwenden" \
        "5) Theme und Icons setzen" \
        "6) SDDM aktivieren" \
        "7) Alle verbleibenden Schritte ausführen" \
        "8) Beenden")

    case "$OPTION" in
        "1) System aktualisieren") update_system ;;
        "2) Essenzielle Pakete installieren") install_packages ;;
        "3) Zsh installieren und konfigurieren") install_zsh ;;
        "4) Konfigurationsdateien anwenden") apply_config ;;
        "5) Theme und Icons setzen") set_theme_and_icons ;;
        "6) SDDM aktivieren") enable_sddm ;;
        "7) Alle verbleibenden Schritte ausführen") run_remaining_steps ;;
        "8) Beenden") exit 0 ;;
        *) zenity --error --text="Ungültige Auswahl" ;;
    esac
}

# Benutzerabfrage
ask_user() {
    zenity --question --text="$1"
    return $?
}

mark_done() {
    done_steps+=("$1")
}

# Systemupdate
update_system() {
    zenity --info --text="System wird aktualisiert..."
    sudo pacman -Syu --noconfirm
    mark_done "update_system"
}

# Essenzielle Pakete installieren
install_packages() {
    zenity --info --text="Installiere essenzielle Pakete..."
    bash ./systemconfig/packages.sh
    mark_done "install_packages"
}

# Zsh installieren
install_zsh() {
    if ask_user "Möchtest du Zsh installieren und konfigurieren?"; then
        zenity --info --text="Installiere und konfiguriere Zsh..."
        bash ./systemconfig/zshinstall.sh
        mark_done "install_zsh"
    else
        zenity --info --text="Überspringe Zsh-Installation."
    fi
}

# Konfigurationsdateien kopieren
apply_config() {
    zenity --info --text="Übertrage Konfigurationsdateien..."
    bash ./systemconfig/config.sh
    mark_done "apply_config"
}

# Theme und Icons setzen
set_theme_and_icons() {
    zenity --info --text="Setze Theme und Icons..."
    bash ./systemconfig/theme.sh
    bash ./systemconfig/icons.sh
    mark_done "set_theme_and_icons"
}

# SDDM aktivieren
enable_sddm() {
    zenity --info --text="Aktiviere SDDM..."
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
    zenity --info --text="Alle Schritte abgeschlossen!"
}

# Menülogik
while true; do
    show_menu
done
