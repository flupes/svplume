#!/bin/bash

# Image resize script using ImageMagick convert
# Resizes JPEG images to maximum 2560x2560 at 95% quality
# Processes recursively and maintains directory structure
#

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ASSETS_MEDIA_IMGS_DIR="${SCRIPT_DIR}/../assets/media/imgs"
ASSETS_MEDIA_IMGS_DIR="$(cd "${SCRIPT_DIR}/../assets/media/imgs" && pwd)"

# Check for required arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 source_directory  [destination_subdirectory]"
    echo ""
    echo "Example 1: create processed under assets/media/imgs"
    echo "    $0 /path/to/photos processed"
    echo ""
    echo "Example 2: replicate the structure under my_large_photos under assets/media/imgs"
    echo "    $0 my_large_photos"     
    echo ""
    echo "Destination will be: ${ASSETS_MEDIA_IMGS_DIR}/${DEST_SUBDIR}"
    exit 1
fi

# Set source and destination directories
IMAGE_DIR="${1%/}"  # Remove trailing slash if present
DEST_SUBDIR="${2:-.}"  # Use "." if no second argument provided
OUTPUT_DIR="${ASSETS_MEDIA_IMGS_DIR}/${DEST_SUBDIR}"

# Validate source directory exists
if [ ! -d "$IMAGE_DIR" ]; then
    echo "Error: Source directory '$IMAGE_DIR' does not exist!"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Counter for processed images
count=0

echo "Starting recursive JPEG resize process..."
echo "Source directory: $IMAGE_DIR"
echo "Destination directory: $OUTPUT_DIR"
echo "----------------------------------------"

# exit 0

# Process JPEG images recursively
while read -r file; do
    # Get relative path using bash parameter substitution
    rel_path="${file#$IMAGE_DIR/}"
    
    # Create output file path maintaining directory structure
    output_file="$OUTPUT_DIR/$rel_path"

    # Create output directory if it doesn't exist
    output_dir=$(dirname "$output_file")
    mkdir -p "$output_dir"
    
    # Get filename for display
    filename=$(basename "$file")
    rel_dir=$(dirname "$rel_path")
    if [ "$rel_dir" = "." ]; then
        display_path="$filename"
    else
        display_path="$rel_dir/$filename"
    fi
    
    # Resize to 2560x2560 at 90% quality
    if convert "$file" -resize "2560x2560>" -quality 95 "$output_file" 2>/dev/null; then
        # Get file size for display
        file_size=$(stat -f%z "$output_file" 2>/dev/null || stat -c%s "$output_file" 2>/dev/null)
        size_kb=$((file_size / 1024))
        echo "✓ Processed: $display_path (${size_kb}KB)"
        ((count++))
    else
        echo "✗ Failed to process: $display_path"
    fi
done < <(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \))

echo "----------------------------------------"
echo "Resize complete! Processed $count images."

# Optional: Display size comparison
if command -v du &> /dev/null; then
    original_size=$(du -sh "$IMAGE_DIR" | cut -f1)
    resized_size=$(du -sh "$OUTPUT_DIR" | cut -f1)
    echo "Original directory size: $original_size"
    echo "Resized directory size: $resized_size"
fi