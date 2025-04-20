#!/bin/sh

emacsclient --create-frame --alternative-editor="" --eval "(ediff-files \"$1\" \"$2\")"
