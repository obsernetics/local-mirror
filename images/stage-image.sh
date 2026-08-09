#!/usr/bin/env bash
# Part 5: stage an OS/system image + checksum on the mirror (run while online).
set -euo pipefail
URL="$1"; DEST=/srv/mirror/images
mkdir -p "$DEST"; cd "$DEST"
curl -fsSLO "$URL"
sha256sum "$(basename "$URL")" | tee -a SHA256SUMS
echo "served at http://<mirror>/images/  (clients verify with: sha256sum -c SHA256SUMS)"
