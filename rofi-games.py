#! python3
import os
from pathlib import Path
import subprocess

library_path = Path.home() / 'bin' / 'games'

gameslist = ""
concat = ""
category = ""
categories = ""

for foldername, subfolder, file in os.walk(library_path):
    for i in subfolder:
        categories = categories + concat + i
        concat = "\n"
list_of_folders = os.listdir(library_path)

category = subprocess.check_output("echo \"" + categories + "\" | rofi -i -dmenu -p \"Category\"", shell=True, encoding='UTF-8')

for item in list_of_folders:
    if str(item.strip()) == str(category.strip()):
        games_path = Path(library_path / str(item))

concat = ""

for i in os.listdir(games_path):
    gameslist = gameslist + concat + i
    concat = "\n"
    list_of_games = os.listdir(games_path)

choice = subprocess.check_output("echo \"" + gameslist + "\" | rofi -i -dmenu -p \"Select Game\"", shell=True, encoding='UTF-8')

for item in list_of_games:
    if str(item.strip()) == str(choice.strip()):
        to_run = Path(games_path / str(item))
        print(to_run)
        subprocess.call(['sh', to_run])