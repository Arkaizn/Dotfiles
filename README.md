# Arch Linux Setup Script

An automated script designed to configure a basic Arch Linux environment. It simplifies the installation of essential packages, Zsh configuration, and GNOME desktop setup, providing an easy path to a fully functional system.

## Table of Contents
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Customization](#customization)
- [Reboot](#reboot)

## Features
- **Package Installation**: Automatically installs essential packages like `xorg`, `gnome`, `gdm`, etc.
- **Zsh Configuration**: Optionally configures Zsh with Oh My Zsh and popular plugins.
- **GNOME Setup**: Enables and starts GNOME Display Manager (GDM).
- **Custom Dotfiles**: Copy your custom dotfiles with ease.

## Getting Started

### Prerequisites
- An Arch Linux base installation.
- Internet connection.

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/arkaizn/dotfiles
   cd dotfiles
   ```

2. Run the setup script:
   ```bash
   bash install.sh
   ```

Follow the prompts to configure Zsh and install the necessary packages.

## Usage
- The script will walk you through the setup process, ensuring your system has the latest updates and packages.
- For advanced users, further customization is possible through editing the scripts.

## Customization
Modify the following files to suit your needs:
- `setup.sh`: Add or remove packages from the `essential_packages` array.
- `dotfiles/zshconnf/zshinstall.sh`: Adjust the Zsh configuration as desired.

## Reboot
Once the installation completes, the system will reboot, and GNOME will be ready to use.

