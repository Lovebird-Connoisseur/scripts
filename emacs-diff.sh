#!/bin/sh

emacs -eval "(ediff-files \"$1\" \"$2\")"
