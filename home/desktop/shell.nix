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

  # NOTE: swaync was removed here. Noctalia now runs as the shell
  # (see ./noctalia.nix) and provides its own notification center and
  # control center — running swaync alongside it would mean two daemons
  # racing to claim the org.freedesktop.Notifications DBus service.
}