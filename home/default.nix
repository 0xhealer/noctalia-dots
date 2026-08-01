{ pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./desktop/default.nix
    ./apps/default.nix
    ./style/default.nix
  ];

  home = {
    username = "healer";
    homeDirectory = "/home/healer";
    
    # State version (matches system stateVersion)
    stateVersion = "24.05";

    # Global environment variables for Wayland/Niri
    sessionVariables = {
      NIXOS_OZONE_WL = "1";               # Force Chromium/Electron apps to use Wayland
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";            # Firefox/Zen Wayland rendering
      QT_QPA_PLATFORM = "wayland;xcb";
      GDK_BACKEND = "wayland,x11,*";
    };
  };

  # NOTE: nixpkgs.config.allowUnfree is intentionally NOT set here.
  # hosts/nixos uses home-manager.useGlobalPkgs, which shares the
  # system's nixpkgs (and its config) with Home Manager — it's set once
  # in modules/packages.nix instead. Setting it again here is deprecated
  # and will eventually be a hard error when useGlobalPkgs is on.

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}