#!/bin/sh

# stops the script if an error or unasigned variable is detected
# or if a pipe fails

set -euo pipefail

free -g | grep "Mem" | tr -s ' ' | cut -d " " -f 2,3 | awk '{print $2,$1}' | sed 's/ /\//'
