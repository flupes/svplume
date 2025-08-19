#!/bin/bash

# Image metadata attribution script using ExifTool
# Adds CC BY-NC-SA license and creator attribution to images
# Processes single file or recursively through directory

# Check for required arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <file_or_directory> [creator_name]"
    echo "Example: $0 /path/to/image.jpg \"John Doe\""
    echo "Example: $0 /path/to/images \"John Doe\""
    echo "Example: $0 /path/to/images (uses default creator)"
    echo ""
    echo "Adds CC BY-NC-SA 4.0 license attribution to single file or all images in directory"
    exit 1
fi

# Check if exiftool is available
if ! command -v exiftool &> /dev/null; then
    echo "Error: exiftool is not installed or not in PATH"
    exit 1
fi

# Set input path and creator
INPUT_PATH="${1%/}"  # Remove trailing slash if present
CREATOR_NAME="${2:-Les Flupes}"  # Use provided name or default

# Check if input is a file or directory
if [ -f "$INPUT_PATH" ]; then
    IS_FILE=true
    echo "Processing single file: $INPUT_PATH"
elif [ -d "$INPUT_PATH" ]; then
    IS_FILE=false
    echo "Processing directory recursively: $INPUT_PATH"
else
    echo "Error: '$INPUT_PATH' is not a valid file or directory!"
    exit 1
fi

# Set license information
CURRENT_YEAR=$(date +%Y)
COPYRIGHT_TEXT="© $CURRENT_YEAR $CREATOR_NAME. Licensed under CC BY-NC-SA 4.0"
LICENSE_URL="https://creativecommons.org/licenses/by-nc-sa/4.0/"
USAGE_TERMS="This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit $LICENSE_URL"

echo "Creator: $CREATOR_NAME"
echo "License: CC BY-NC-SA 4.0"
echo "Copyright: $COPYRIGHT_TEXT"
echo "----------------------------------------"

# Counter for processed images
count=0

# Function to process a single image file
process_image() {
    local file="$1"
    local display_name="$2"
    
    # Add metadata using exiftool (preserve existing values)
    if exiftool \
        -overwrite_original \
        -if 'not $Artist' -EXIF:Artist="$CREATOR_NAME" \
        -if 'not $Copyright' -EXIF:Copyright="$COPYRIGHT_TEXT" \
        -if 'not $XMP-dc:Creator' -XMP-dc:Creator="$CREATOR_NAME" \
        -if 'not $XMP-dc:Rights' -XMP-dc:Rights-x-default="$COPYRIGHT_TEXT" \
        -if 'not $XMP-xmpRights:UsageTerms' -XMP-xmpRights:UsageTerms-x-default="$USAGE_TERMS" \
        -if 'not $XMP-cc:License' -XMP-cc:License="$LICENSE_URL" \
        -if 'not $XMP-xmpRights:WebStatement' -XMP-xmpRights:WebStatement="$LICENSE_URL" \
        "$file" &>/dev/null; then
        echo "✓ Added attribution: $display_name"
        ((count++))
    else
        echo "✗ Failed to process: $display_name"
    fi
}

# Process based on input type
if [ "$IS_FILE" = true ]; then
    # Process single file
    filename=$(basename "$INPUT_PATH")
    process_image "$INPUT_PATH" "$filename"
else
    # Process images recursively in directory
    while read -r file; do
        # Get relative path from source directory
        rel_path="${file#$INPUT_PATH/}"
        process_image "$file" "$rel_path"
    done < <(find "$INPUT_PATH" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.tiff" -o -iname "*.tif" \))
fi

echo "----------------------------------------"
echo "Attribution complete! Processed $count images."
echo ""
echo "Added metadata (only if not already present):"
echo "  EXIF Artist: $CREATOR_NAME"
echo "  EXIF Copyright: $COPYRIGHT_TEXT"
echo "  XMP Creator: $CREATOR_NAME"
echo "  XMP Rights: $COPYRIGHT_TEXT"
echo "  XMP Usage Terms: $USAGE_TERMS"
echo "  XMP License URL: $LICENSE_URL"
echo "  XMP Web Statement: $LICENSE_URL"
echo ""
echo "Note: Existing metadata values are preserved and not overwritten"
