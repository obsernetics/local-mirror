#!/usr/bin/env bash
# Part 5: mirror Helm charts and build the repo index (run while online).
set -euo pipefail
MIRROR_URL="${1:-http://10.10.0.1/helm}"; shift || true
DEST=/srv/mirror/helm
mkdir -p "$DEST"
# also serve the helm binary itself for offline clients:
sudo cp "$(command -v helm)" "$DEST/helm" 2>/dev/null || true
# pull the charts you need (add repos first with `helm repo add`), e.g.:
#   helm pull podinfo/podinfo -d "$DEST"
for chart in "$@"; do helm pull "$chart" -d "$DEST"; done
helm repo index "$DEST" --url "$MIRROR_URL"
echo "chart repo ready at $MIRROR_URL"
