#!/bin/bash

# copy hypr config
cp -r ./.config/hypr ~/.config

# copy alacritty config
cp -r ./.config/alacritty ~/.config

# copy waybar config
cp -r ./.config/waybar ~/.config

# copy fastfetch config
cp -r ./.config/fastfetch ~/.config

# copy swaync config
cp -r ./.config/swaync ~/.config

# copy wlogout config
cp -r ./.config/wlogout ~/.config

# copy Wofi config
cp -r ./.config/wofi ~/.config


# copy and run services
bash ./services.sh