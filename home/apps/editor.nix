{ pkgs, config, ... }:

{
  # -------------------------------------------------------------------------
  # Ghostty Terminal
  # -------------------------------------------------------------------------
  # No confirmed Stylix target for Ghostty (see ../style/stylix.nix) —
  # colors are hand-wired directly from config.lib.stylix.colors, which
  # is Stylix's own documented mechanism for targets it doesn't natively
  # support. Regenerates whenever stylix.image changes + rebuild.
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      font-family = "Hack Nerd Font";
      font-size = 12;
      background-opacity = 0.85;

      window-padding-x = 12;
      window-padding-y = 12;
      confirm-close-surface = false;
      gtk-single-instance = true;
      gtk-titlebar = false;

      background = config.lib.stylix.colors.withHashtag.base00;
      foreground = config.lib.stylix.colors.withHashtag.base05;
      cursor-color = config.lib.stylix.colors.withHashtag.base0D;
      palette = [
        "0=${config.lib.stylix.colors.withHashtag.base00}"
        "1=${config.lib.stylix.colors.withHashtag.base08}"
        "2=${config.lib.stylix.colors.withHashtag.base0B}"
        "3=${config.lib.stylix.colors.withHashtag.base0A}"
        "4=${config.lib.stylix.colors.withHashtag.base0D}"
        "5=${config.lib.stylix.colors.withHashtag.base0E}"
        "6=${config.lib.stylix.colors.withHashtag.base0C}"
        "7=${config.lib.stylix.colors.withHashtag.base05}"
        "8=${config.lib.stylix.colors.withHashtag.base03}"
        "9=${config.lib.stylix.colors.withHashtag.base08}"
        "10=${config.lib.stylix.colors.withHashtag.base0B}"
        "11=${config.lib.stylix.colors.withHashtag.base0A}"
        "12=${config.lib.stylix.colors.withHashtag.base0D}"
        "13=${config.lib.stylix.colors.withHashtag.base0E}"
        "14=${config.lib.stylix.colors.withHashtag.base0C}"
        "15=${config.lib.stylix.colors.withHashtag.base07}"
      ];
    };
  };

  # -------------------------------------------------------------------------
  # Kitty Terminal
  # -------------------------------------------------------------------------
  # Colors owned entirely by Stylix's kitty target now (stylix.targets.
  # kitty.enable in ../style/stylix.nix) — no manual color include here
  # anymore. Only non-color behavior settings stay in this file.
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
    };

    settings = {
      font_family = "Hack Nerd Font";
      font_size = 12;
      background_opacity = "0.85";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 12;
      hide_window_decorations = "yes";
    };
  };

  # -------------------------------------------------------------------------
  # Alacritty Terminal
  # -------------------------------------------------------------------------
  # Colors owned entirely by Stylix's alacritty target now
  # (stylix.targets.alacritty.enable in ../style/stylix.nix) — no manual
  # color import here anymore.
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 0.85;
        padding = {
          x = 12;
          y = 12;
        };
        decorations = "None";
      };

      font = {
        normal = {
          family = "Hack Nerd Font";
          style = "Regular";
        };
        size = 12;
      };
    };
  };
}
