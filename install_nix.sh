#!/usr/bin/env bash

ARCH="x86_64"
VERSION="1.11.7"
OS="linux"

set -e

cd "$HOME"
mkdir -p bin

# Download proot
wget 'https://github.com/proot-me/proot-static-build/blob/master/static/proot-x86_64?raw=true' -O bin/proot
chmod +x bin/proot

# Download nix
curl "https://nixos.org/releases/nix/nix-$VERSION/nix-$VERSION-$ARCH-$OS.tar.bz2" | tar xvjf -
mv "nix-$VERSION-$ARCH-$OS" nix_data

# Install with-nix script
cat << EOF > bin/with-nix
proot -b \$HOME/nix_data:/nix bash -c "source ~/.nix-profile/etc/profile.d/nix.sh; exec \$(printf " %q" "\$@")"
EOF
chmod +x bin/with-nix

# Install enable-nix script
cat << EOF > bin/enable-nix
with-nix \$SHELL
EOF
chmod +x bin/enable-nix

# Run nix setup
bin/with-nix nix_data/install

