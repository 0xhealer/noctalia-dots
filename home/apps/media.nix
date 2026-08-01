{ pkgs, ... }:

{

  programs.mpv = {
    enable = true;

    config = {

      profile = "gpu-hq";
      vo = "gpu-next";
      gpu-api = "vulkan";

      keep-open = "yes";
      autofit-larger = "80%x80%";
      cursor-autohide = 1000;

      sub-font = "JetBrainsMono Nerd Font";
      sub-font-size = 24;
    };
  };
}