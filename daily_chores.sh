#!/bin/sh

# stops the script if an error or unasigned variable is detected
# or if a pipe fails

set -euo pipefail

echo "Chores: $(grep -cE "TODO" ~/Documents/Notes/Daily.org)"
