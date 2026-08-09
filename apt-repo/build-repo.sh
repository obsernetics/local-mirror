#!/usr/bin/env bash
# Part 2: build a signed apt repo on the mirror host (run while online).
set -euo pipefail
ROOT=/srv/mirror/apt
sudo apt-get install -y apt-utils dpkg-dev gnupg
mkdir -p "$ROOT/pool/main" "$ROOT/dists/stable/main/binary-amd64"

# 1) download the .deb packages you want to mirror
cd "$ROOT/pool/main"
apt-get download hello tree      # add the packages / security updates you need

# 2) build the package index
cd "$ROOT"
dpkg-scanpackages pool /dev/null > dists/stable/main/binary-amd64/Packages
gzip -kf dists/stable/main/binary-amd64/Packages

# 3) build + sign the Release file
cat > /tmp/aptftp.conf <<CFG
APT::FTPArchive::Release {
  Origin "Obsernetics"; Label "Obsernetics Mirror"; Suite "stable";
  Codename "stable"; Architectures "amd64"; Components "main";
};
CFG
apt-ftparchive -c /tmp/aptftp.conf release dists/stable > dists/stable/Release
gpg --clearsign -o dists/stable/InRelease dists/stable/Release
gpg -abs -o dists/stable/Release.gpg dists/stable/Release

# 4) export the public key for clients
gpg --export mirror@obsernetics.local > "$ROOT/obsernetics-mirror.gpg"
echo "signed apt repo ready under $ROOT"
