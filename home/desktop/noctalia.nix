{ pkgs, inputs, ... }:

{

  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    systemd.enable = false;

    settings = {
      theme = {
        mode = "dark";

        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper.enabled = false;
      backdrop.enabled = false;
    };
  };
}
