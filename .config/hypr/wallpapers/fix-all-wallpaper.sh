#!/bin/bash

# Set folders
SOURCE_FOLDER="./wal"
BACKUP_FOLDER="./old"

# Create backup folder if it doesn't exist
mkdir -p "$BACKUP_FOLDER"

# Process each image inside the source folder
for img in "$SOURCE_FOLDER"/*.{png,jpg,jpeg}; do
    # Check if the file exists
    [ -e "$img" ] || continue
    filename=$(basename "$img")
    echo "Processing $filename..."

    # Move the original image to backup folder
    mv "$img" "$BACKUP_FOLDER/$filename"

    # Only apply cropping (no resizing)
    magick "$BACKUP_FOLDER/$filename" -gravity center -crop 16:9 "$SOURCE_FOLDER/$filename"
done

echo "All images cropped and originals moved to '$BACKUP_FOLDER'. 🌑✨"
