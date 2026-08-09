#!/usr/bin/env bash
# Part 4: point an offline client's npm at the local verdaccio.
set -euo pipefail
MIRROR="${1:-10.10.0.1}"
npm config set registry "http://$MIRROR:4873"
echo "npm now installs from http://$MIRROR:4873 (no internet needed)"
