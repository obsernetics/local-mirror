#!/usr/bin/env bash
# Part 1: set up the mirror host (Debian/Ubuntu).
set -euo pipefail
sudo apt-get update
sudo apt-get install -y nginx
sudo mkdir -p /srv/mirror/{apt,pypi,containers,helm}
sudo cp nginx-mirror.conf /etc/nginx/sites-available/mirror
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/mirror /etc/nginx/sites-enabled/mirror
sudo nginx -t && sudo systemctl reload nginx
echo "mirror host ready at http://<this-host>/"
