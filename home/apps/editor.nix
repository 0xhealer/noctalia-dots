{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Ghostty Terminal (Imports Matugen Colors)
  # -------------------------------------------------------------------------
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    # enableBashIntegration = true;
    # enableZshIntegration = true;

    settings = {
      font-family = "Hack Nerd Font";
      font-size = 12;
      background-opacity = 0.85;

      window-padding-x = 12;
      window-padding-y = 12;
      confirm-close-surface = false;
      gtk-single-instance = true;
      gtk-titlebar = false;

      # Path where Matugen writes Ghostty's dynamic color file
      config-file = "~/.config/ghostty/colors";
    };
  };

  # -------------------------------------------------------------------------
  # Kitty Terminal (Includes Matugen Colors)
  # -------------------------------------------------------------------------
  programs.kitty = {
    enable = true;
    enableFishIntegration = true;
    # enableBashIntegration = true;
    # enableZshIntegration = true;

    settings = {
      font_family = "Hack Nerd Font";
      font_size = 12;
      background_opacity = "0.85";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 12;
      hide_window_decorations = "yes";
    };

    # Includes the active Matugen dynamic color file
    extraConfig = ''
      include ~/.config/kitty/colors.conf
    '';
  };

  # -------------------------------------------------------------------------
  # Alacritty Terminal (Imports Matugen Colors)
  # -------------------------------------------------------------------------
  programs.alacritty = {
    enable = true;

    settings = {
      # Imports the active Matugen dynamic TOML palette
      general = {
        import = [ "~/.config/alacritty/colors.toml" ];
      };

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