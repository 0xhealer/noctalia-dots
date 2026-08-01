{ pkgs, config, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
in
{
  # -------------------------------------------------------------------------
  # Fastfetch System Information Tool
  # -------------------------------------------------------------------------
  # No confirmed Stylix target for fastfetch — key/title colors are
  # hand-wired to config.lib.stylix.colors directly (same mechanism as
  # Ghostty in ../apps/editor.nix), so nothing here is a static hex.
  # Module list/style adapted from israrkhan-cys/Arch-_hyprland_rice's
  # fastfetch config, NixOS-ified (no pacman reference, no personal logo
  # file that doesn't exist on this machine).
  programs.fastfetch = {
    enable = true;

    settings = {
      display.separator = " ";

      modules = [
        "break"
        {
          type = "custom";
          format = "[90m  [31m  [32m  [33m  [34m  [35m  [36m  [37m";
        }
        "break"
        { type = "title"; keyWidth = 10; }
        "break"
        { type = "os"; key = " "; keyColor = c.base0D; }
        { type = "kernel"; key = " "; keyColor = c.base0D; }
        { type = "packages"; format = "{}"; key = " "; keyColor = c.base0D; }
        { type = "shell"; key = " "; keyColor = c.base0D; }
        { type = "terminal"; key = " "; keyColor = c.base0D; }
        { type = "wm"; key = " "; keyColor = c.base0D; }
        { type = "cursor"; key = " "; keyColor = c.base0D; }
        { type = "terminalfont"; key = " "; keyColor = c.base0D; }
        { type = "uptime"; key = " "; keyColor = c.base0D; }
        { type = "datetime"; format = "{1}-{3}-{11}"; key = " "; keyColor = c.base0D; }
        { type = "media"; key = "󰝚 "; keyColor = c.base0D; }
        "break"
        {
          type = "custom";
          format = "[90m  [31m  [32m  [33m  [34m  [35m  [36m  [37m";
        }
        "break"
      ];
    };
  };
}
