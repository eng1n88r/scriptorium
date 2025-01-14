#!/bin/bash

# Directory containing the files to be unzipped
SOURCE_DIR=$1

# Directory to store extracted files
DEST_DIR=$2

# Check if both arguments are provided
if [ -z "$SOURCE_DIR" ] || [ -z "$DEST_DIR" ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Find all files recursively in the source directory but exclude the destination directory
find "$SOURCE_DIR" -path "$DEST_DIR" -prune -o -type f -print | while read -r file; do
    if file "$file" | grep -q "Zip archive data"; then
        # Get the base name of the file (without extension)
        base_name=$(basename "$file" .zip)
        
        # Set the target directory for the extraction
        target_dir="$DEST_DIR/$base_name"
        mkdir -p "$target_dir"

        # Extract files directly into the target folder
        (cd "$target_dir" && unzip -qo "$file")
        echo "Extracted $file into $target_dir"
    else
        echo "Skipped $file (not a zip archive)"
    fi
done