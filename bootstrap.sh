#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/0xhealer/noctalia-dots.git"
TARGET_DIR="$HOME/.local/share/noctalia-dots"
BACKUP_EXT="backup"

echo "==> Step 0: Configuring Nix (experimental features, no interactive prompts)..."
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi
if ! grep -q "accept-flake-config" ~/.config/nix/nix.conf 2>/dev/null; then
  echo "accept-flake-config = true" >> ~/.config/nix/nix.conf
fi

echo "==> Step 1: Checking for Git..."
if ! command -v git &> /dev/null; then
  echo "--> Git not found, installing temporarily via nix-shell..."
  export PATH="$(nix-build '<nixpkgs>' -A git --no-out-link)/bin:$PATH"
fi

echo "==> Step 2: Adding swap as an OOM safety net for the build..."
if ! swapon --show=NAME --noheadings | grep -q "/swapfile"; then
  if [ ! -f /swapfile ]; then
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
  fi
  sudo swapon /swapfile
  if ! grep -q "^/swapfile" /etc/fstab 2>/dev/null; then
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null
  fi
  echo "--> Swap active: $(free -h | awk '/Swap/ {print $2}')"
else
  echo "--> Swap already active, skipping."
fi

echo "==> Step 3: Syncing dotfiles repository..."
mkdir -p "$(dirname "$TARGET_DIR")"
if [ ! -d "$TARGET_DIR/.git" ]; then
  git clone "$REPO_URL" "$TARGET_DIR"
else
  echo "--> Local repository found. Hard resetting to fetch cleanly..."
  git -C "$TARGET_DIR" fetch origin main
  git -C "$TARGET_DIR" reset --hard origin/main
fi

cd "$TARGET_DIR"

echo "==> Step 4: Copying system hardware configuration..."
mkdir -p hosts/nixos
if [ -f /etc/nixos/hardware-configuration.nix ]; then
  cp -f /etc/nixos/hardware-configuration.nix hosts/nixos/hardware-configuration.nix
fi

echo "==> Step 5: Staging files for Nix Flakes..."
git add -f hosts/nixos/hardware-configuration.nix
git add -A

echo "==> Step 6: Clearing stale Home Manager backup files from earlier runs..."
# Home Manager refuses to overwrite an existing "<file>.$BACKUP_EXT" rather
# than risk destroying something you meant to keep -- but on a rerun after
# an earlier partial/failed activation, those backups are just leftover
# copies of files this same repo already manages, safe to clear so the
# activation isn't blocked waiting on manual cleanup.
find "$HOME" -maxdepth 3 -name "*.${BACKUP_EXT}" -print -delete 2>/dev/null || true

echo "==> Step 7: Rebuilding system with Flakes (this can take a while on first run)..."
sudo NIX_CONFIG="experimental-features = nix-command flakes
accept-flake-config = true" nixos-rebuild switch --flake .#nixos --impure

echo "==> Done. Reboot to log into Niri automatically (no session picker needed)."
