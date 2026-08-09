#!/usr/bin/env bash
# Enable unattended security upgrades on a client, sourced only from the
# local mirror (works with the internet fully cut, over the LAN).
set -euo pipefail
apt-get install -y --no-download unattended-upgrades
install -m 0644 51obsernetics-mirror /etc/apt/apt.conf.d/51obsernetics-mirror
install -m 0644 20auto-upgrades      /etc/apt/apt.conf.d/20auto-upgrades
# Dry-run to confirm the origin is picked up:
unattended-upgrade --dry-run --debug || true
