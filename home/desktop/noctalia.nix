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
        # Static builtin theme rather than "wallpaper" source: Noctalia's
        # own palette generator is a separate algorithm from matugen, so
        # pointing it at the wallpaper too wouldn't guarantee it lands on
        # the same hexes as everything else — it'd just be dynamic in a
        # way that could clash with matugen's dynamic result instead of
        # matching it. A fixed Catppuccin Mocha bar is a closer visual
        # match to the matugen fallback palette used elsewhere (see
        # ../style/matugen.nix) and never disagrees with it.
        source = "builtin";
        builtin = "Catppuccin";
      };

      # Wallpaper is already handled declaratively by awww + waypaper +
      # matugen (see ./tools.nix and ../style/matugen.nix), so Noctalia's
      # own wallpaper/backdrop management is turned off to avoid two
      # systems fighting over the same job. This pairs with the
      # "Option 2: Stationary Wallpaper" niri layer-rule in ./niri.nix.
      wallpaper.enabled = false;
      backdrop.enabled = false;
    };
  };
}
