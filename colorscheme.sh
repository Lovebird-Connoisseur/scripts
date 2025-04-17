#!/bin/sh

# stops the script if an error or unasigned variable is detected
# or if a pipe fails

set -eu

hour=$(date +"%H")

if [ "$hour" -gt 16 ] || [ "$hour" -lt 6 ]; then
    theme=dark
else
    theme=light
fi


wal --theme "$(find ~/.config/colorschemes/$theme/ -type f -print | shuf -n 1)"
sleep 5
xrdb -load ~/.cache/wal/colors.Xresources
# reload apps that need doing so (zathura and qutebrowser)
