#!/usr/bin/env bash
# Script to find the workspace of the active media player window and focus it

player=$(playerctl metadata --format '{{ playerName }}' 2>/dev/null)
title=$(playerctl metadata --format '{{ title }}' 2>/dev/null)

if [ -z "$player" ]; then
    exit 0
fi

ws_id=""

# Step 1: Match by title in hyprctl clients
if [ -n "$title" ]; then
    # Keep only alphanumeric characters and spaces for regex safety
    clean_title=$(echo "$title" | sed 's/[^a-zA-Z0-9 ]//g')
    if [ -n "$clean_title" ]; then
        ws_id=$(hyprctl clients -j | jq -r --arg title "$clean_title" '.[] | select(.title | gsub("[^a-zA-Z0-9 ]"; "") | contains($title)) | .workspace.id' | head -n 1)
    fi
fi

# Step 2: Fallback to matching by class name (case-insensitive)
if { [ -z "$ws_id" ] || [ "$ws_id" = "null" ]; } && [ -n "$player" ]; then
    player_lower=$(echo "$player" | tr '[:upper:]' '[:lower:]')
    if [[ "$player_lower" =~ zen ]]; then
        p_class="zen"
    else
        p_class="$player_lower"
    fi
    ws_id=$(hyprctl clients -j | jq -r --arg p "$p_class" '.[] | select((.class | ascii_downcase) | contains($p)) | .workspace.id' | head -n 1)
fi

# Step 3: Focus workspace if found
if [ -n "$ws_id" ] && [ "$ws_id" != "null" ]; then
    hyprctl dispatch "hl.dsp.focus({ workspace = $ws_id })"
fi
