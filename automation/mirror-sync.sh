#!/usr/bin/env bash
# Rebuild and re-sign every mirror index from whatever is currently on disk.
# Runs on the mirror host, driven by mirror-sync.timer (daily). When the
# internet is up the fetch scripts refresh content; this script republishes it.
set -euo pipefail

MIRROR_ROOT=${MIRROR_ROOT:-/srv/mirror}
GPG_KEY=${GPG_KEY:-mirror@obsernetics.local}
log() { printf '[mirror-sync] %s\n' "$*"; }

# --- apt: rescan pool, regenerate Packages/Release, clearsign ---
apt_repo="$MIRROR_ROOT/apt"
if [ -d "$apt_repo" ]; then
  cd "$apt_repo"
  dpkg-scanpackages --multiversion pool /dev/null > dists/stable/main/binary-amd64/Packages
  gzip -9c dists/stable/main/binary-amd64/Packages > dists/stable/main/binary-amd64/Packages.gz
  apt-ftparchive -c aptftp.conf release dists/stable > dists/stable/Release
  gpg --batch --yes --default-key "$GPG_KEY" -abs \
      -o dists/stable/Release.gpg dists/stable/Release
  gpg --batch --yes --default-key "$GPG_KEY" --clearsign \
      -o dists/stable/InRelease dists/stable/Release
  count=$(grep -c '^Package: ' dists/stable/main/binary-amd64/Packages || true)
  log "apt repo re-indexed and signed (${count} packages)"
fi

# --- helm: refresh the chart index ---
helm_repo="$MIRROR_ROOT/helm"
if [ -d "$helm_repo" ]; then
  helm repo index "$helm_repo" --url "http://10.10.0.1/helm"
  log "helm index regenerated"
fi

# --- images: refresh checksums for staged OS images ---
img_dir="$MIRROR_ROOT/images"
if [ -d "$img_dir" ]; then
  ( cd "$img_dir" && sha256sum *.tar.gz *.img* 2>/dev/null > SHA256SUMS || true )
  log "image checksums refreshed"
fi

log "sync complete"
