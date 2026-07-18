#!/usr/bin/env bash
# Prints the current active workspace as a Roman Numeral

active=$(hyprctl activeworkspace -j 2>/dev/null | grep -o '"name": *"[0-9]*"' | grep -o '[0-9]*')

case "$active" in
	1) roman="Ⅰ";;
	2) roman="Ⅱ";;
	3) roman="Ⅲ";;
	4) roman="Ⅳ";;
	5) roman="Ⅴ";;
	*) roman="$active";;
esac

echo "<span weight='bold' color='#94e2d5'>$roman</span>"
