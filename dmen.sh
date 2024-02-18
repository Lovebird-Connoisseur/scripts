#!/bin/sh

# Import the colors
. "${HOME}/.cache/wal/colors.sh"

dmenu_run -fn 'IBM Plex Mono-14' -i -p "> " -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"
