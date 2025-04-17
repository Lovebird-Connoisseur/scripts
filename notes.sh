#!/bin/sh

# stops the script if an error or unasigned variable is detected
# or if a pipe fails

set -eu

$EDITOR ~/Documents/Notes/"$1".org
