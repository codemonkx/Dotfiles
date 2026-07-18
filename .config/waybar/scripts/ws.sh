#!/usr/bin/env bash
# Prints a styled Roman numeral for workspace $1
# - Always shows workspaces 1 to 5
# - Dynamically shows workspaces > 5 if active or occupied
# - Otherwise outputs nothing, which hides it in Waybar

n="$1"
active=$(hyprctl activeworkspace -j 2>/dev/null | jq -r ".id")
occupied=$(hyprctl workspaces -j 2>/dev/null | jq -r ".[] | select(.id == $n) | .id")

# Convert to Roman numeral
case "$n" in
	1) roman="Ⅰ";;
	2) roman="Ⅱ";;
	3) roman="Ⅲ";;
	4) roman="Ⅳ";;
	5) roman="Ⅴ";;
	6) roman="Ⅵ";;
	7) roman="Ⅶ";;
	8) roman="Ⅷ";;
	9) roman="Ⅸ";;
	10) roman="Ⅹ";;
	*) roman="$n";;
esac

# Hide if > 5 and not active and not occupied
if [ "$n" -gt 5 ] && [ "$n" != "$active" ] && [ -z "$occupied" ]; then
	exit 0
fi

if [ "$n" = "$active" ]; then
	echo "<span weight='bold' color='#94e2d5'>$roman</span>"
else
	# Muted gray for all non-active workspaces
	echo "<span color='#6c7086'>$roman</span>"
fi
