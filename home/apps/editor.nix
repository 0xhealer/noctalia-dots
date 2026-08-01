{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      window-padding-x = 12;
      window-padding-y = 12;
      confirm-close-surface = false;
      gtk-single-instance = true;
      gtk-titlebar = false;
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
    };

    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 12;
      hide_window_decorations = "yes";
    };
  };

  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 12;
          y = 12;
        };
        decorations = "None";
      };
    };
  };
}
