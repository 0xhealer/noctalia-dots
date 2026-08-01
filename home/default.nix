{ pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./desktop/default.nix
    ./apps/default.nix
    ./style/default.nix
  ];

  home = {
    username = "healer";
    homeDirectory = "/home/healer";

    stateVersion = "24.05";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      GDK_BACKEND = "wayland,x11,*";
    };
  };

  programs.home-manager.enable = true;
}