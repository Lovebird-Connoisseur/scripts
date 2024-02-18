#! python

import os
from pathlib import Path
import shutil

downloads = Path.home() / 'Downloads'
documents = Path.home() / 'Documents'
books = Path.home() / 'Documents' / 'Books'
pictures = Path.home() / 'Pictures'
videos = Path.home() / 'Videos'
books = Path.home() / 'Documents' / 'Books'

for i in os.listdir(downloads):
    source = Path(downloads) / i
    if i[-4:] == ".png":
        shutil.move(source, pictures)
    elif i[-4:] == "jpeg":
        shutil.move(source, pictures)
    elif i[-4:] == "epub":
        shutil.move(source, books)
    elif i[-4:] == ".pdf":
        shutil.move(source, documents)
    elif i[-4:] == ".mp4":
        shutil.move(source, videos)
else:
    pass
