#!/usr/bin/env bash
# Part 2: point an (offline) client at the local mirror. MIRROR=host/ip of the mirror.
set -euo pipefail
MIRROR="${1:-10.10.0.1}"
# disable the default (unreachable) sources
sudo mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.disabled 2>/dev/null || true
sudo truncate -s 0 /etc/apt/sources.list 2>/dev/null || true
# trust the mirror key + add the local source
sudo install -d /etc/apt/keyrings
curl -fsSL "http://$MIRROR/apt/obsernetics-mirror.gpg" | sudo tee /etc/apt/keyrings/obsernetics.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/obsernetics.gpg] http://$MIRROR/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/obsernetics.list
sudo apt-get update
echo "client now installs packages from http://$MIRROR/apt (no internet needed)"
