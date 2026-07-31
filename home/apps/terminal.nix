{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      background_opacity = "0.9";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.9;
        padding = { x = 10; y = 10; };
      };
      font = {
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        size = 11;
      };
    };
  };

  # Zoxide (Smart `cd` alternative)
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  # Fzf (Fuzzy Finder)
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Bat (`cat` clone with syntax highlighting)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  # Eza (`ls` replacement with icons)
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };
}