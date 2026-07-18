#!/usr/bin/env bash

## Power Menu (Wayland-friendly rofi script mode)

dir="$HOME/.config/rofi/powermenu/type-4"
mode="$dir/pm_mode.sh"

rofi -show powermenu -modi "powermenu:$mode" \
    -theme ~/.config/rofi/theme.rasi \
    -disable-history \
    -kb-primary-paste "" \
    -kb-secondary-paste "" \
    -kb-copy ""
