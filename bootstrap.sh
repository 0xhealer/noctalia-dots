#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/0xhealer/noctalia-dots.git"
TARGET_DIR="$HOME/.local/share/noctalia-dots"

echo "==> Step 0: Enabling Nix experimental features..."
# Write to the user-specific config to bypass the read-only /etc directory
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

echo "==> Step 1: Checking for Git..."
if ! command -v git &> /dev/null; then
  echo "--> Git not found, installing temporarily via nix-shell..."
  export PATH="$(nix-build '<nixpkgs>' -A git --no-out-link)/bin:$PATH"
fi

echo "==> Step 2: Syncing dotfiles repository..."
mkdir -p "$(dirname "$TARGET_DIR")"
if [ ! -d "$TARGET_DIR/.git" ]; then
  git clone "$REPO_URL" "$TARGET_DIR"
else
  echo "--> Local repository found. Hard resetting to fetch cleanly..."
  git -C "$TARGET_DIR" fetch origin main
  git -C "$TARGET_DIR" reset --hard origin/main
fi

cd "$TARGET_DIR"

echo "==> Step 3: Copying system hardware configuration..."
mkdir -p hosts/nixos
if [ -f /etc/nixos/hardware-configuration.nix ]; then
  cp -f /etc/nixos/hardware-configuration.nix hosts/nixos/hardware-configuration.nix
fi

echo "==> Step 4: Staging files for Nix Flakes..."
# Force git to track hardware-configuration.nix even if gitignored
git add -f hosts/nixos/hardware-configuration.nix
git add -A

echo "==> Step 5: Rebuilding system with Flakes..."
# The NIX_CONFIG environment variable takes care of sudo inheriting the features
sudo NIX_CONFIG="experimental-features = nix-command flakes" nixos-rebuild switch --flake .#nixos --impure

echo "==> Done!"