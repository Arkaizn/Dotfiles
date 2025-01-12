#!/bin/bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/wal"
CURRENT_FILE="$HOME/.config/hypr/wallpapers/.current_wallpaper"
WALLPAPERS=("$WALLPAPER_DIR"/*)

# Get the index of the current wallpaper
if [ -f "$CURRENT_FILE" ]; then
  CURRENT_INDEX=$(cat "$CURRENT_FILE")
else
  CURRENT_INDEX=0
fi

# Calculate the next wallpaper index
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

# Clear the current wallpaper before setting the next one
swww restore

# Set the new wallpaper
swww img "${WALLPAPERS[$NEXT_INDEX]}" --transition-type fade --transition-duration 1

# Save the current index
echo "$NEXT_INDEX" > "$CURRENT_FILE"

wal -i "${WALLPAPERS[$NEXT_INDEX]}"
bash /home/$USER/.config/swaync/refresh.sh
pywalfox update