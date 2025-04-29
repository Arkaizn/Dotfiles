#!/bin/bash
url=$(playerctl metadata mpris:artUrl | sed 's/^file:\/\///')
cp "$url" ~/.config/hypr/hyprlock/album_art.png
