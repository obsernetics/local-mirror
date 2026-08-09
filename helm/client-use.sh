#!/usr/bin/env bash
# Part 5: use the local Helm chart repo from an offline client. MIRROR=host/ip.
set -euo pipefail
MIRROR="${1:-10.10.0.1}"
# grab the helm binary from the mirror if needed:
[ -x /usr/local/bin/helm ] || { curl -fsSL "http://$MIRROR/helm/helm" -o /tmp/helm && chmod +x /tmp/helm && sudo install /tmp/helm /usr/local/bin/helm; }
helm repo add localmirror "http://$MIRROR/helm"
helm repo update
helm search repo localmirror
