#!/usr/bin/env python3
import sys
import os
import colorsys
from PIL import Image

def get_colors(image_path):
    img = Image.open(image_path)
    img = img.resize((150, 150)) # Downscale for speed
    img = img.quantize(colors=16).convert('RGB')
    colors = img.getcolors()
    colors = sorted(colors, key=lambda x: x[0], reverse=True)
    return [c[1] for c in colors]

def adjust_color(rgb, h_offset=0.0, s_mult=1.0, v_mult=1.0, v_set=None):
    h, s, v = colorsys.rgb_to_hsv(rgb[0]/255.0, rgb[1]/255.0, rgb[2]/255.0)
    h = (h + h_offset) % 1.0
    s = max(0.0, min(1.0, s * s_mult))
    v = v_set if v_set is not None else max(0.0, min(1.0, v * v_mult))
    r, g, b = colorsys.hsv_to_rgb(h, s, v)
    return (int(r*255), int(g*255), int(b*255))

def rgb_to_hex(rgb):
    return "#%02x%02x%02x" % rgb

def main():
    if len(sys.argv) < 2:
        print("Usage: theme_generator.py <image_path>")
        sys.exit(1)
        
    image_path = sys.argv[1]
    if not os.path.exists(image_path):
        print(f"File {image_path} does not exist")
        sys.exit(1)
        
    # Get colors
    rgb_colors = get_colors(image_path)
    
    # Sort colors by saturation to find the most vibrant one
    vibrant_colors = sorted(rgb_colors, key=lambda c: colorsys.rgb_to_hsv(c[0]/255.0, c[1]/255.0, c[2]/255.0)[1], reverse=True)
    accent_rgb = vibrant_colors[0]
    
    # Boost accent saturation and value for visibility
    accent_rgb = adjust_color(accent_rgb, s_mult=1.5, v_set=0.85)
    accent_h, _, _ = colorsys.rgb_to_hsv(accent_rgb[0]/255.0, accent_rgb[1]/255.0, accent_rgb[2]/255.0)
    
    # Generate background states (Catppuccin base/mantle/crust/surface)
    base = adjust_color(accent_rgb, s_mult=0.15, v_set=0.08)
    mantle = adjust_color(accent_rgb, s_mult=0.12, v_set=0.06)
    crust = adjust_color(accent_rgb, s_mult=0.08, v_set=0.04)
    surface0 = adjust_color(accent_rgb, s_mult=0.20, v_set=0.14)
    surface1 = adjust_color(accent_rgb, s_mult=0.22, v_set=0.20)
    surface2 = adjust_color(accent_rgb, s_mult=0.24, v_set=0.26)
    
    # Generate foreground text colors
    text = adjust_color(accent_rgb, s_mult=0.05, v_set=0.92)
    subtext0 = adjust_color(accent_rgb, s_mult=0.08, v_set=0.80)
    subtext1 = adjust_color(accent_rgb, s_mult=0.10, v_set=0.70)
    overlay0 = adjust_color(accent_rgb, s_mult=0.15, v_set=0.45)
    
    # Generate harmonic palette colors by shifting hue
    red = adjust_color(accent_rgb, h_offset=0.0 - accent_h, s_mult=1.0, v_set=0.85)
    peach = adjust_color(accent_rgb, h_offset=0.08 - accent_h, s_mult=1.0, v_set=0.88)
    yellow = adjust_color(accent_rgb, h_offset=0.15 - accent_h, s_mult=1.0, v_set=0.88)
    green = adjust_color(accent_rgb, h_offset=0.33 - accent_h, s_mult=1.0, v_set=0.82)
    teal = adjust_color(accent_rgb, h_offset=0.45 - accent_h, s_mult=1.0, v_set=0.82)
    sky = adjust_color(accent_rgb, h_offset=0.55 - accent_h, s_mult=1.0, v_set=0.85)
    blue = adjust_color(accent_rgb, h_offset=0.62 - accent_h, s_mult=1.0, v_set=0.85)
    lavender = adjust_color(accent_rgb, h_offset=0.68 - accent_h, s_mult=1.0, v_set=0.85)
    mauve = adjust_color(accent_rgb, h_offset=0.78 - accent_h, s_mult=1.0, v_set=0.82)
    pink = adjust_color(accent_rgb, h_offset=0.90 - accent_h, s_mult=1.0, v_set=0.85)
    rosewater = adjust_color(accent_rgb, h_offset=0.95 - accent_h, s_mult=0.5, v_set=0.88)

    colors = {
        "accent": rgb_to_hex(accent_rgb),
        "base": rgb_to_hex(base),
        "mantle": rgb_to_hex(mantle),
        "crust": rgb_to_hex(crust),
        "surface0": rgb_to_hex(surface0),
        "surface1": rgb_to_hex(surface1),
        "surface2": rgb_to_hex(surface2),
        "text": rgb_to_hex(text),
        "subtext0": rgb_to_hex(subtext0),
        "subtext1": rgb_to_hex(subtext1),
        "overlay0": rgb_to_hex(overlay0),
        "red": rgb_to_hex(red),
        "peach": rgb_to_hex(peach),
        "yellow": rgb_to_hex(yellow),
        "green": rgb_to_hex(green),
        "teal": rgb_to_hex(teal),
        "sky": rgb_to_hex(sky),
        "blue": rgb_to_hex(blue),
        "lavender": rgb_to_hex(lavender),
        "mauve": rgb_to_hex(mauve),
        "pink": rgb_to_hex(pink),
        "rosewater": rgb_to_hex(rosewater),
    }

    # Write files
    # 1. Hyprland Borders config
    with open("/home/nx02/.config/hypr/configs/colors.lua", "w") as f:
        f.write('return {\n')
        f.write(f'    active_border = {{ colors = {{ "rgba({colors["accent"].lstrip("#")}ff)", "rgba({colors["mauve"].lstrip("#")}ff)" }}, angle = 45 }},\n')
        f.write(f'    inactive_border = "rgba({colors["surface0"].lstrip("#")}aa)",\n')
        f.write('}\n')

    # 2. Waybar Theme
    with open("/home/nx02/.config/waybar/theme.css", "w") as f:
        f.write('/* Dynamically generated color palette */\n\n')
        for name, val in colors.items():
            f.write(f'@define-color {name} {val};\n')
        f.write('\n/* Semantic mappings */\n')
        f.write('@define-color main-br @surface0;\n')
        f.write(f'@define-color main-bg rgba({crust[0]}, {crust[1]}, {crust[2]}, 0.60);\n')
        f.write('@define-color main-fg @text;\n')
        f.write(f'@define-color hover-bg rgba({base[0]}, {base[1]}, {base[2]}, 0.60);\n')
        f.write('@define-color hover-fg alpha(@main-fg, 0.75);\n')
        f.write('@define-color outline shade(@main-bg, 0.5);\n')
        f.write(f'@define-color workspaces rgba({mantle[0]}, {mantle[1]}, {mantle[2]}, 0.60);\n')
        f.write(f'@define-color temperature rgba({mantle[0]}, {mantle[1]}, {mantle[2]}, 0.60);\n')
        f.write(f'@define-color memory rgba({base[0]}, {base[1]}, {base[2]}, 0.60);\n')
        f.write(f'@define-color cpu rgba({surface0[0]}, {surface0[1]}, {surface0[2]}, 0.60);\n')
        f.write(f'@define-color time rgba({surface0[0]}, {surface0[1]}, {surface0[2]}, 0.60);\n')
        f.write(f'@define-color date rgba({base[0]}, {base[1]}, {base[2]}, 0.60);\n')
        f.write(f'@define-color tray rgba({mantle[0]}, {mantle[1]}, {mantle[2]}, 0.60);\n')
        f.write(f'@define-color volume rgba({mantle[0]}, {mantle[1]}, {mantle[2]}, 0.60);\n')
        f.write(f'@define-color backlight rgba({base[0]}, {base[1]}, {base[2]}, 0.60);\n')
        f.write(f'@define-color battery rgba({surface0[0]}, {surface0[1]}, {surface0[2]}, 0.60);\n')

    # 3. Kitty Theme
    with open("/home/nx02/.config/kitty/theme.conf", "w") as f:
        f.write('# Dynamically generated Kitty colors\n\n')
        f.write(f'background            {colors["base"]}\n')
        f.write(f'foreground            {colors["text"]}\n')
        f.write(f'cursor                {colors["accent"]}\n')
        f.write(f'cursor_text_color     {colors["base"]}\n')
        f.write(f'selection_background  {colors["accent"]}\n')
        f.write(f'selection_foreground  {colors["text"]}\n')
        f.write(f'color0                {colors["crust"]}\n')
        f.write(f'color8                {colors["surface0"]}\n')
        f.write(f'color1                {colors["red"]}\n')
        f.write(f'color9                {colors["red"]}\n')
        f.write(f'color2                {colors["green"]}\n')
        f.write(f'color10               {colors["green"]}\n')
        f.write(f'color3                {colors["yellow"]}\n')
        f.write(f'color11               {colors["yellow"]}\n')
        f.write(f'color4                {colors["blue"]}\n')
        f.write(f'color12               {colors["blue"]}\n')
        f.write(f'color5                {colors["mauve"]}\n')
        f.write(f'color13               {colors["mauve"]}\n')
        f.write(f'color6                {colors["teal"]}\n')
        f.write(f'color14               {colors["teal"]}\n')
        f.write(f'color7                {colors["subtext0"]}\n')
        f.write(f'color15               {colors["text"]}\n')
        f.write(f'active_border_color   {colors["accent"]}\n')
        f.write(f'inactive_border_color {colors["surface0"]}\n')

    # 4. Rofi Theme
    with open("/home/nx02/.config/rofi/colors/dynamic.rasi", "w") as f:
        f.write('* {\n')
        f.write(f'    background:     {colors["base"]}99;\n')
        f.write(f'    background-alt: {colors["mantle"]}99;\n')
        f.write(f'    foreground:     {colors["text"]}FF;\n')
        f.write(f'    selected:       {colors["accent"]}FF;\n')
        f.write(f'    active:         {colors["teal"]}FF;\n')
        f.write(f'    urgent:         {colors["red"]}FF;\n')
        f.write('}\n')

    # 5. SwayNC Theme
    with open("/home/nx02/.config/swaync/theme.css", "w") as f:
        f.write(f'@define-color cc-bg rgba({base[0]}, {base[1]}, {base[2]}, 0.80);\n')
        f.write(f'@define-color border-color rgba({surface0[0]}, {surface0[1]}, {surface0[2]}, 0.5);\n')
        f.write(f'@define-color text-color {colors["text"]};\n')
        f.write(f'@define-color widget-bg rgba({mantle[0]}, {mantle[1]}, {mantle[2]}, 0.5);\n')
        f.write(f'@define-color widget-bg-hover rgba({mantle[0]}, {mantle[1]}, {mantle[2]}, 0.8);\n')
        f.write(f'@define-color accent {colors["accent"]};\n')
        f.write(f'@define-color secondary-accent {colors["blue"]};\n')
        f.write(f'@define-color red-color {colors["red"]};\n')
        f.write(f'@define-color muted-text {colors["overlay0"]};\n')
        f.write(f'@define-color secondary-accent-alpha-20 rgba({blue[0]}, {blue[1]}, {blue[2]}, 0.2);\n')
        f.write(f'@define-color secondary-accent-alpha-40 rgba({blue[0]}, {blue[1]}, {blue[2]}, 0.4);\n')
        f.write(f'@define-color accent-alpha-15 rgba({accent_rgb[0]}, {accent_rgb[1]}, {accent_rgb[2]}, 0.15);\n')

    # Hot-reload signals
    os.system("killall -USR2 waybar 2>/dev/null")
    os.system("killall -USR1 kitty 2>/dev/null")
    os.system("swaync-client -R 2>/dev/null && swaync-client -rs 2>/dev/null")

if __name__ == "__main__":
    main()
