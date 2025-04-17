#!/bin/sh

for f in `find . -type f -name "*.lisp"`; do
    exe=$(basename -- "$f" .lisp)
    echo "Compiling \"$f\"..."
    sbcl --load "$f" --eval "(sb-ext:save-lisp-and-die \"$exe\" :executable t :toplevel #'main)"
    mv "$exe" ../
    echo "Done"
done
