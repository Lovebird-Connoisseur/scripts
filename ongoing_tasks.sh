#!/bin/sh

# stops the script if an error or unasigned variable is detected
# or if a pipe fails

set -euo pipefail

tasks="$(wc -l < ~/Documents/Notes/tasks.org)"
echo "tasks: $((tasks-2))"
