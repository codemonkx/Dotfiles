#!/usr/bin/env bash
# Script to output media player source (website/app name) in JSON format for Waybar

player=$(playerctl metadata --format '{{ playerName }}' 2>/dev/null)
title=$(playerctl metadata --format '{{ title }}' 2>/dev/null)
artist=$(playerctl metadata --format '{{ artist }}' 2>/dev/null)
status=$(playerctl status 2>/dev/null)

if [ -z "$player" ] || [ -z "$status" ]; then
    # Output empty string if nothing is playing
    echo '{"text": "", "tooltip": "", "class": "stopped"}'
    exit 0
fi

# Icon based on status
if [ "$status" = "Playing" ]; then
    icon="󰐊"
    class="playing"
else
    icon="󰏤"
    class="paused"
fi

# Determine source website/app name
source_name=""
if [ "$player" = "spotify" ]; then
    source_name="Spotify"
elif [[ "$player" =~ (firefox|chromium|chrome|zen) ]]; then
    if [[ "$title" =~ [yY]ou[tT]ube ]]; then
        source_name="YouTube"
    elif [[ "$title" =~ [nN]etflix ]]; then
        source_name="Netflix"
    elif [[ "$title" =~ [sS]ound[cC]loud ]]; then
        source_name="SoundCloud"
    elif [[ "$title" =~ [tT]witch ]]; then
        source_name="Twitch"
    elif [[ "$title" =~ [dD]isney ]]; then
        source_name="Disney+"
    elif [[ "$title" =~ [pP]rime ]]; then
        source_name="Prime Video"
    else
        source_name="Browser"
    fi
else
    source_name="$(echo "$player" | sed 's/./\U&/')"
fi

# Format tooltip text with full title/artist info
tooltip_text="Source: $source_name"
if [ -n "$title" ]; then
    # Escape double quotes for JSON safety
    clean_title=$(echo "$title" | sed 's/"/\\"/g')
    if [ -n "$artist" ]; then
        clean_artist=$(echo "$artist" | sed 's/"/\\"/g')
        tooltip_text="$clean_title - $clean_artist"
    else
        tooltip_text="$clean_title"
    fi
fi

# Output JSON
echo "{\"text\": \"$icon $source_name\", \"tooltip\": \"$tooltip_text\", \"class\": \"$class\"}"
