#!/usr/bin/env bash
# Part 3: mirror images into the local registry (run while online). MIRROR=host:5000
set -euo pipefail
MIRROR="${1:-10.10.0.1:5000}"; shift || true
IMAGES=("$@"); [ ${#IMAGES[@]} -eq 0 ] && IMAGES=(library/alpine:3.20 library/nginx:alpine)
for img in "${IMAGES[@]}"; do
  echo ">> mirroring $img"
  skopeo copy --dest-tls-verify=false "docker://docker.io/$img" "docker://$MIRROR/$img"
done
curl -s "http://$MIRROR/v2/_catalog"; echo
