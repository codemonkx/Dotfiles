#!/usr/bin/env bash

# Directories
WALLPAPER_DIR="/home/nx02/.config/Wallpaper"
STATE_FILE="/home/nx02/.config/hypr/.current_wallpaper"
SDDM_THEME_DIR="/usr/share/sddm/themes/windows_7"

# Create state directory if not exists
mkdir -p "$(dirname "$STATE_FILE")"

# Get active wallpaper
if [ -f "$STATE_FILE" ]; then
    CURRENT_WALLPAPER=$(cat "$STATE_FILE")
else
    CURRENT_WALLPAPER="Space.jpg"
fi

# Function to apply wallpaper
apply_wallpaper() {
    local wp="$1"
    if [ -f "$WALLPAPER_DIR/$wp" ]; then
        # Transition via swww
        swww img "$WALLPAPER_DIR/$wp" --transition-type outer --transition-fps 60
        # Save state
        echo "$wp" > "$STATE_FILE"
        # Update SDDM background if folder exists
        if [ -d "$SDDM_THEME_DIR" ]; then
            cp "$WALLPAPER_DIR/$wp" "$SDDM_THEME_DIR/background.png" 2>/dev/null || true
        fi
        # Generate and apply matching color theme to all apps
        python3 /home/nx02/.config/hypr/scripts/theme_generator.py "$WALLPAPER_DIR/$wp" &>/dev/null &
    fi
}

# If arguments are passed, handle them
if [ "$1" == "--init" ]; then
    # Load last saved wallpaper or default Space.jpg
    apply_wallpaper "$CURRENT_WALLPAPER"
    exit 0
elif [ "$1" == "--select" ]; then
    # Create thumbnails directory if not exists
    mkdir -p "$WALLPAPER_DIR/.thumbnails"

    # List wallpapers with icons and show as a grid in Rofi
    selected=$(
        # Generate thumbnails in parallel
        for img in "$WALLPAPER_DIR"/*; do
            if [ -f "$img" ]; then
                name=$(basename "$img")
                thumb="$WALLPAPER_DIR/.thumbnails/$name"
                if [ ! -f "$thumb" ]; then
                    convert -resize 300x "$img" "$thumb" &
                fi
            fi
        done
        wait

        # Output entries to Rofi using thumbnails
        for img in "$WALLPAPER_DIR"/*; do
            if [ -f "$img" ]; then
                name=$(basename "$img")
                thumb="$WALLPAPER_DIR/.thumbnails/$name"
                printf "%s\0icon\x1f%s\n" "$name" "$thumb"
            fi
        done | rofi -dmenu -i -p "Select Wallpaper" -show-icons -theme-str '
            window {
                width: 780px;
                height: 580px;
            }
            mainbox {
                padding: 20px;
                spacing: 20px;
            }
            listview {
                columns: 3;
                fixed-height: false;
                spacing: 20px;
                padding: 10px;
                scrollbar: true;
            }
            element {
                orientation: vertical;
                children: [ "element-icon", "element-text" ];
                padding: 15px;
                spacing: 10px;
                border-radius: 15px;
                background-color: transparent;
            }
            element-icon {
                size: 140px;
                horizontal-align: 0.5;
            }
            element-text {
                horizontal-align: 0.5;
            }
        '
    )
    if [ -n "$selected" ]; then
        apply_wallpaper "$selected"
    fi
    exit 0
fi

# Default: show selector
apply_wallpaper "$CURRENT_WALLPAPER"
