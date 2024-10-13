#!/bin/bash

sudo pacman -S openrgb

sudo cp ./dotfiles/openrgbconf/openrgb.service /etc/systemd/system/
sudo cp ./dotfiles/openrgbconf/start-openrgb.sh /root/
sudo mkdir /root/.config/OpenRGB/
sudo cp ./dotfiles/openrgbconf/purple.orp /root/.config/OpenRGB/

sudo systemctl daemon-reload
sudo systemctl enable openrgb.service
sudo systemctl start openrgb.service
