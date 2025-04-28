#!/bin/bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/wal"

# Display wallpaper selection menu
menu() {
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

main() {
    # Get user selection
    choice=$(menu | wofi -c ~/.config/wofi/config1 -s ~/.config/wofi/style1.css --show dmenu --prompt "Select Wallpaper:" -n)

    # Exit if no selection was made
    if [[ -z "$choice" ]]; then
        echo "No wallpaper selected."
        exit 1
    fi

    selected_wallpaper=$(echo "$choice" | sed 's/^img://')

    # Set the wallpaper
    swww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5

    # Generate colors with pywal
    wal -i "$selected_wallpaper"

    # Reload swaync theme
    swaync-client --reload-css

    # Apply pywal theme to Kitty terminal
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf

    # Update Firefox theme using pywalfox
    pywalfox update

    # Extract colors from wal cache and convert to rgb(r,g,b) format
    awk '{
    hex=substr($0,2);
    r=strtonum("0x" substr(hex,1,2));
    g=strtonum("0x" substr(hex,3,2));
    b=strtonum("0x" substr(hex,5,2));
    printf "export color%d=\"rgb(%d,%d,%d)\"\n", NR-1, r, g, b;
    }' ~/.cache/wal/colors > ~/.cache/wal/hyprlock_colors

    # Save current wallpaper to a common location
    cp -r "$selected_wallpaper" ~/.config/hypr/wallpapers/pywallpaper.jpg
}

main
