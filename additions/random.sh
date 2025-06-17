#!/bin/bash

# intsall xbox controller drivers 
yay -S xpadneo-dkms
yay -S btop
yay -S openlinkhub

# tailscale
yay -S tailscale
sudo systemctl enable --now tailscaled.service
sudo tailscale set --operator=$USER 
sudo tailscale login
tailscale set --accept-dns=false 
tailscale status

# nordvpn
sudo groupadd nordvpn
sudo usermod -aG nordvpn $USER
sudo systemctl enable --now nordvpnd.service
nordvpn login
nordvpn login --callback "continue Button URL from Nordvpn"