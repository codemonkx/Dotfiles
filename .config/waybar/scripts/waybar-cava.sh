#!/usr/bin/env bash
# High-fidelity CAVA audio visualizer script for Waybar

# Create config directory
mkdir -p ~/.config/cava

# Write premium config for CAVA with monstercat smoothing and 60fps
cat <<EOF > ~/.config/cava/config_waybar
[general]
bars = 12
framerate = 60

[input]
method = pipewire
source = auto

[output]
method = raw
data_format = ascii
ascii_max_range = 7
bar_delimiter = 59

[smoothing]
monstercat = 1
noise_reduction = 0.77
EOF

# Run CAVA and translate heights to Unicode block characters
# stdbuf ensures output is not buffered
exec stdbuf -oL -eL cava -p ~/.config/cava/config_waybar | sed -u \
    -e 's/0/ /g' \
    -e 's/1/▂/g' \
    -e 's/2/▃/g' \
    -e 's/3/▄/g' \
    -e 's/4/▅/g' \
    -e 's/5/▆/g' \
    -e 's/6/▇/g' \
    -e 's/7/█/g' \
    -e 's/;//g'
