#!/usr/bin/env bash
# Part 4: install a Python package on an offline client from the local mirror.
set -euo pipefail
MIRROR="${1:-10.10.0.1}"; shift
pip3 install --no-index --find-links "http://$MIRROR/pypi/packages/" --trusted-host "$MIRROR" "$@"
