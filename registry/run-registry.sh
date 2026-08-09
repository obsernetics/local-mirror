#!/usr/bin/env bash
# Part 3: run a local container registry on the mirror host.
set -euo pipefail
sudo apt-get install -y docker.io skopeo
sudo mkdir -p /srv/registry
sudo docker run -d --restart=always --name registry \
  -p 5000:5000 -v /srv/registry:/var/lib/registry registry:2
echo "registry up at http://<mirror>:5000"
