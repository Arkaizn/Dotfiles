#!/bin/bash

(
    git clone https://github.com/vinceliuice/Graphite-gtk-theme
    cd Graphite-gtk-theme
    ./install.sh --tweaks float colorful nord rimless -t teal
)
gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-teal-Dark-nord'