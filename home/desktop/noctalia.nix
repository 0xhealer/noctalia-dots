{ pkgs, inputs, ... }:

{
  # ---------------------------------------------------------------------
  # Noctalia Shell — Home Manager Module
  # ---------------------------------------------------------------------
  # This is what actually turns "having the noctalia package installed"
  # into "noctalia is your running desktop shell". It declaratively
  # writes ~/.config/noctalia/ instead of relying on whatever the app's
  # own settings UI leaves behind.
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    # Noctalia also has a systemd user service option, but the docs
    # recommend NOT using it together with a compositor-spawned instance
    # (spawn-at-startup "noctalia" in niri.nix) — using both starts two
    # instances. We autostart it from niri instead, so systemd stays off.
    systemd.enable = false;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      # Wallpaper is already handled declaratively by swww + waypaper +
      # matugen (see ./tools.nix and ../style/matugen.nix), so Noctalia's
      # own wallpaper/backdrop management is turned off to avoid two
      # systems fighting over the same job. This pairs with the
      # "Option 2: Stationary Wallpaper" niri layer-rules below.
      wallpaper.enabled = false;
      backdrop.enabled = false;
    };
  };
}
