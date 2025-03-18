#!/bin/bash

(
    curl -L -o Bibata-Modern-Ice.tar.xz https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz
    7z x Bibata-Modern-Ice.tar.xz
    7z x Bibata-Modern-Ice.tar
    mkdir ~/.icons/
    cp -r Bibata-Modern-Ice ~/.icons/Bibata-Modern-Ice
)

# Icon Theme ()
cp -fr ./systemconfig/Icons/Solarized-Violet-gtk-theme-iconpack/ ~/.icons/Icons/Solarized-Violet-gtk-theme-iconpack/
gsettings set org.gnome.desktop.interface icon-theme 'Solarized-Violet-gtk-theme-iconpack'