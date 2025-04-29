#!/bin/bash

# Funktion zum Abrufen der Metadaten mit playerctl
get_metadata() {
    key=$1
    playerctl metadata --format "{{ $key }}" 2>/dev/null
}

# Abrufen der URL des Albumcovers
url=$(get_metadata "mpris:artUrl")
if [ -z "$url" ]; then
    echo ""
else
    if [[ "$url" == file://* ]]; then
        url=${url#file://}
    fi
    echo "$url"
fi
