#!/usr/bin/env bash
# Install the sync script + systemd timer on the mirror host.
set -euo pipefail
install -m 0755 mirror-sync.sh /usr/local/bin/mirror-sync.sh
install -m 0644 mirror-sync.service /etc/systemd/system/mirror-sync.service
install -m 0644 mirror-sync.timer   /etc/systemd/system/mirror-sync.timer
systemctl daemon-reload
systemctl enable --now mirror-sync.timer
systemctl list-timers mirror-sync.timer --no-pager
