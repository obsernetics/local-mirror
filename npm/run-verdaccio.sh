#!/usr/bin/env bash
# Part 4: run verdaccio (npm registry/proxy) on the mirror and pre-cache packages (online).
set -euo pipefail
sudo docker run -d --restart=always --name verdaccio -p 4873:4873 verdaccio/verdaccio
# pre-cache packages by installing them through verdaccio while online:
#   npm install --registry http://localhost:4873 <pkg> ...
echo "verdaccio up at http://<mirror>:4873"
