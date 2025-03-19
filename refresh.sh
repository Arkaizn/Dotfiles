#!/bin/bash

# Farbdefinitionen
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Backup-Zielverzeichnis (Ändere dies nach Bedarf)
BACKUP_DIR="$HOME/Backups"

# Array zur Verfolgung abgeschlossener Schritte
done_steps=()

# Funktion zum Überprüfen, ob ein Schritt bereits erledigt wurde
is_done() {
    [[ " ${done_steps[*]} " =~ " $1 " ]]
}

# Menü anzeigen mit wofi
show_menu() {
    choice=$(echo -e "1) System aktualisieren\n2) Konfigurationsdateien anwenden\n3) Theme und Icons setzen\n4) Backup wichtige Dateien\n5) Beenden" | wofi --dmenu -n --width 600 --height 400 --lines 10 --prompt "Wähle eine Option:" 2>/dev/null | cut -d')' -f1 | tr -d ' ')
    
    case "$choice" in
        1) is_done update_system || update_system ;;
        2) is_done apply_config || apply_config ;;
        3) is_done set_theme_and_icons || set_theme_and_icons ;;
        4) is_done backup_files || backup_files ;;
        5) echo -e "${GREEN}Installation beendet.${NC}"; exit 0 ;;
        *) echo -e "${RED}Ungültige Auswahl. Bitte erneut versuchen.${NC}" ;;
    esac
    if [[ -z "$choice" ]]; then
        echo "Abbruch durch ESC oder leere Eingabe."
        exit 0
    fi
}

# Schritt als erledigt markieren
mark_done() {
    done_steps+=("$1")
}

# Systemupdate durchführen
update_system() {
    echo -e "${YELLOW}System wird aktualisiert...${NC}"
    if sudo pacman -Syu --noconfirm; then
        mark_done update_system
    else
        echo -e "${RED}Fehler beim Aktualisieren des Systems!${NC}"
    fi
}

# Konfigurationsdateien anwenden
apply_config() {
    echo -e "${YELLOW}Übertrage Konfigurationsdateien...${NC}"
    if bash ./systemconfig/config.sh; then
        mark_done apply_config
    else
        echo -e "${RED}Fehler beim Anwenden der Konfiguration!${NC}"
    fi
}

# Theme und Icons setzen
set_theme_and_icons() {
    echo -e "${YELLOW}Setze Theme und Icons...${NC}"
    if bash ./systemconfig/theme.sh && bash ./systemconfig/icons.sh; then
        mark_done set_theme_and_icons
    else
        echo -e "${RED}Fehler beim Setzen von Theme und Icons!${NC}"
    fi
}

# Backup wichtiger Dateien und Ordner
backup_files() {
    echo -e "${YELLOW}Backup wird erstellt...${NC}"

    # Sicherzustellen, dass das Backup-Verzeichnis existiert
    mkdir -p "$BACKUP_DIR"

    # Liste der wichtigen Dateien/Ordner (Ändere dies nach Bedarf)
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
            echo -e "${CYAN}Gesichert: $item${NC}"
        else
            echo -e "${RED}Übersprungen (nicht gefunden): $item${NC}"
        fi
    done

    echo -e "${GREEN}Backup abgeschlossen!${NC}"
    mark_done backup_files
}

# Hauptmenü in einer Schleife anzeigen
while true; do
    show_menu || break
done
