{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # -------------------------------------------------------------------------
  # Import Spicetify Home Manager Module
  # -------------------------------------------------------------------------
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  # -------------------------------------------------------------------------
  # Spicetify Configuration (Declarative Spotify Customization)
  # -------------------------------------------------------------------------
  programs.spicetify = {
    enable = true;

    # Theme selection using spicetify-nix package themes
    theme = spicePkgs.themes.text;

    # Useful Spotify Extensions
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle          # Improved shuffle algorithm
      hidePodcasts     # Clean up sidebar/home feed
      adblock          # Ad-blocking extension
    ];

    # Spicetify Marketplace App
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];
  };
}