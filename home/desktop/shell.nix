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

        include = "~/.config/fuzzel/colors.ini";
      };
    };
  };

}