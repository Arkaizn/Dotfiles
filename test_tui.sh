#!/bin/bash

# Farbdefinitionen
PURPLE="\033[0;35m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Array zur Verfolgung abgeschlossener Schritte
done_steps=()

# Überprüfen, ob 'whiptail' installiert ist und es installieren, falls es fehlt
check_whiptail_installed() {
    if ! command -v whiptail &>/dev/null; then
        sudo pacman -Sy --noconfirm whiptail
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
        1) show_action_description "System wird aktualisiert. Dies wird alle installierten Pakete auf den neuesten Stand bringen." && update_system ;;
        2) show_action_description "Essenzielle Pakete werden installiert. Dies umfasst grundlegende Pakete für das System." && install_packages ;;
        3) show_action_description "Zsh wird installiert und konfiguriert. Möchten Sie Zsh als Standard-Shell verwenden?" && install_zsh ;;
        4) show_action_description "Konfigurationsdateien werden übertragen. Dies umfasst die Anpassung des Systems und der Anwendungen." && apply_config ;;
        5) show_action_description "Theme und Icons werden gesetzt. Dies betrifft das visuelle Erscheinungsbild des Systems." && set_theme_and_icons ;;
        6) show_action_description "SDDM wird aktiviert. Dies ist der Display-Manager für den Login-Bildschirm." && enable_sddm ;;
        7) show_action_description "Alle verbleibenden Schritte werden ausgeführt, um das System vollständig zu konfigurieren." && run_remaining_steps ;;
        8) whiptail --msgbox "Installation beendet." 6 50; exit 0 ;;
        *) whiptail --msgbox "Ungültige Auswahl. Bitte erneut versuchen." 6 50 ;;
    esac
}

# Funktion zur Benutzerabfrage mit whiptail
ask_user() {
    whiptail --yesno "$1" 6 50
    return $?
}

# Zeige eine Beschreibung der Aktion
show_action_description() {
    whiptail --msgbox "$1" 6 50
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
