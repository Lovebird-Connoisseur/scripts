#! python

from pathlib import Path
import os
import stat

p = Path.home()
i3_config_path = Path.home() / ".config" / "i3" / "config"
picom_config_path = Path.home() / ".config" / "picom.conf"

# ask for name, class, category, id and game type
game_class = input("Class: ")
game_category = input("Category: ")
game_id = input("Game ID: ")
game_type = input("Game type (lutris/steam/heroic): ")

# add exceptions to i3wm and picom

i3_conf = open(i3_config_path, "a")
i3_conf.write(
    f'for_window [class="{game_class}"] move workspace 2, floating disable, focus, gaps inner current set 0, gaps outer current set 0, border pixel 0\n'
)
i3_conf.close()

picom_conf = open(picom_config_path, "r")
text = iter(picom_conf.readlines())
picom_conf.close()

picom_conf = open(picom_config_path, "w")

for line in text:
    picom_conf.write(line)
    if line == """    "100:class_g = 'qutebrowser'",\n""":
        next_line = next(text)
        picom_conf.write(f"""    "100:class_g = '{game_class}'",\n""")
        picom_conf.write(next_line)
