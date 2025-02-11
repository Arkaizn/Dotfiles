#!/bin/bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/wal"
CURRENT_FILE="$HOME/.config/hypr/wallpapers/.current_wallpaper"

# Ensure the wallpaper directory is not empty
shopt -s nullglob
WALLPAPERS=("$WALLPAPER_DIR"/*)
shopt -u nullglob

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Get the index of the current wallpaper
if [ -f "$CURRENT_FILE" ]; then
    CURRENT_WALLPAPER=$(cat "$CURRENT_FILE")
    CURRENT_INDEX=$(printf "%s\n" "${WALLPAPERS[@]}" | grep -nFx "$CURRENT_WALLPAPER" | cut -d: -f1)
    CURRENT_INDEX=$((CURRENT_INDEX - 1))
else
    CURRENT_INDEX=0
fi

# Calculate the next wallpaper index
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Set the new wallpaper
swww img "$NEXT_WALLPAPER" --transition-type fade --transition-duration 1

# Save the current wallpaper path
echo "$NEXT_WALLPAPER" > "$CURRENT_FILE"

# Apply pywal colors and refresh settings
wal -i "$NEXT_WALLPAPER"
bash "$HOME/.config/swaync/refresh.sh"
pywalfox update
