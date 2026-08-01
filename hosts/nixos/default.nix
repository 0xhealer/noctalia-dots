{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  users.users.healer = {
    isNormalUser = true;
    description = "healer";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" "docker" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}