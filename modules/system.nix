{ pkgs, ... }:

{
  # Bootloader Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Nix Flakes & CLI Tools
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true; # Automatically deduplicate nix store
  };

  # Automatic garbage collection — without this, every generation's
  # packages stay in /nix/store forever and disk usage only grows.
  # auto-optimise-store (above) dedupes identical files across store
  # paths, but doesn't delete anything unreferenced — this does.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Cap how many old boot entries stick around (keeps /boot from
  # filling up on smaller ESPs — a real concern on a laptop's SSD in a
  # way it wasn't on a 250GB VM disk).
  boot.loader.systemd-boot.configurationLimit = 10;

  # Power Management Daemon
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Hardware Graphics Acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Locale & Timezone Settings
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # System-wide Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # NixOS Release Version (Do not change after initial install)
  system.stateVersion = "24.05";
}