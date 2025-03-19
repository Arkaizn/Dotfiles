# Arch Linux Installation Script

## Overview

This repository contains a set of scripts to automate the installation and configuration of an Arch Linux system with Hyprland. The installation process includes system updates, essential package installations, configuration setup, and theming.

## Features

- Updates the system
- Installs essential packages
- Installs and configures Zsh
- Applies configuration files
- Sets up themes and icons
- Enables SDDM (Simple Desktop Display Manager)
- Runs all steps in sequence if desired

## Prerequisites

Ensure you have the following before running the script:

- A working Arch Linux installation
- `sudo` privileges
- Internet connection

## Installation and Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/Dotfiles.git
   cd Dotfiles
   ```

2. Run the script:

   ```bash
   ./install.sh
   ```

## Script Functionality

When executed, the script provides a menu with the following options:

1. **System aktualisieren** - Updates the system using `pacman -Syu`.
2. **Essenzielle Pakete installieren** - Installs essential packages listed in `scripts/packages.sh`.
3. **Zsh installieren und konfigurieren** - Installs and configures Zsh using `scripts/zshinstall.sh`.
4. **Konfigurationsdateien anwenden** - Applies custom configurations from `scripts/config.sh`.
5. **Theme und Icons setzen** - Applies a predefined theme and icons using `scripts/theme.sh` and `scripts/icons.sh`.
6. **SDDM aktivieren** - Enables the SDDM display manager.
7. **Alle verbleibenden Schritte ausführen** - Runs all remaining steps in sequence.
8. **Beenden** - Exits the script.

## Customization

You can modify the individual scripts inside the `scripts/` folder to adjust package lists, configurations, or themes according to your preferences.

## Cleanup

If necessary, temporary files such as the `.dialogrc` file are cleaned up upon script exit.

## Troubleshooting

If you encounter issues, try the following:

- Ensure `dialog` is installed (`sudo pacman -Sy dialog`).
- Run the script with `bash -x ./install.sh` to debug.
- Check log outputs for errors.

