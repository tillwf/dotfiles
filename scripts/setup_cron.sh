#!/usr/bin/env bash
set -euo pipefail

TMPFILE="$(mktemp)"
trap 'rm -f "$TMPFILE"' EXIT

echo "*/30 * * * * fswebcam -r 1280x960 --jpeg 100 -S 10 \"/home/${USER}/Pictures/.Moi/wc-\`date +\%Y-\%m-\%dT\%H-\%M\`.jpeg\"" > "$TMPFILE"
echo "*/30 * * * * DISPLAY=:1 scrot \"/home/${USER}/Pictures/.Moi/sc-\`date +\%Y-\%m-\%dT\%H-\%M\`.jpeg\"" >> "$TMPFILE"
crontab "$TMPFILE"
