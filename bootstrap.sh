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
git add -f hosts/nixos/hardware-configuration.nix
git add -A

echo "==> Step 5: Clearing stale Home Manager backup files from earlier runs..."
# Home Manager refuses to overwrite an existing "<file>.$BACKUP_EXT" rather
# than risk destroying something you meant to keep -- but on a rerun after
# an earlier partial/failed activation, those backups are just leftover
# copies of files this same repo already manages, safe to clear so the
# activation isn't blocked waiting on manual cleanup.
find "$HOME" -maxdepth 3 -name "*.${BACKUP_EXT}" -print -delete 2>/dev/null || true

echo "==> Step 6: Updating the niri-flake input..."
# niri-flake's Nix schema (which niri settings are valid to write in
# home/desktop/niri.nix) is baked into whatever commit of niri-flake
# is pinned in flake.lock -- it does NOT automatically track whichever
# niri package (stable/niri-unstable) is selected in modules/display.nix.
# Newer niri features (like blur, added in niri 26.04) only become
# usable here once niri-flake's own pinned commit has added schema
# support for them, which requires updating this specific input.
nix flake lock --update-input niri --extra-experimental-features "nix-command flakes"
git add -f flake.lock

echo "==> Step 7: Rebuilding system with Flakes (this can take a while on first run)..."
# NOTE: swap is no longer set up here with shell commands -- on NixOS,
# /etc/fstab is generated declaratively and read-only at runtime, so
# `tee -a /etc/fstab` (what an earlier version of this script tried)
# fails outright. Swap is now declared as swapDevices in
# modules/system.nix instead, and gets created automatically as part
# of the rebuild below -- no separate step needed here.
sudo NIX_CONFIG="experimental-features = nix-command flakes
accept-flake-config = true" nixos-rebuild switch --flake .#nixos --impure

echo "==> Done. Reboot to log into Niri automatically (no session picker needed)."
