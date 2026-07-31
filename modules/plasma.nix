{ pkgs, ... }:

{
  # Enable KDE Plasma 6 Desktop Environment
  services.desktopManager.plasma6.enable = true;

  # Enable KDE Connect Integration
  programs.kdeconnect.enable = true;

  # Exclude bloated/unneeded default KDE utilities
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
    khelpcenter
  ];
}