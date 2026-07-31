{ pkgs, inputs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        prompt = "'❯ '";
        terminal = "ghostty";
        layer = "overlay";
        width = 35;
        horizontal-pad = 20;
        vertical-pad = 15;
        inner-pad = 10;
        border-width = 2;
        corner-radius = 12;
        
        # Pull dynamic colors from Matugen's generated output file
        include = "~/.config/fuzzel/colors.ini";
      };
    };
  };

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-width = 380;
      control-center-height = 600;
      notification-window-width = 350;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
    };
  };
}