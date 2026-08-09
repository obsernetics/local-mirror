#!/usr/bin/env bash
# Part 4: mirror Python packages as wheels (run while online).
set -euo pipefail
DEST=/srv/mirror/pypi/packages
mkdir -p "$DEST"
pip3 download "$@" -d "$DEST"     # e.g. ./download-wheels.sh requests cowsay tqdm
echo "wheels in $DEST are served at http://<mirror>/pypi/packages/"
