{ pkgs, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "9.9.9.9"]

    # System Firewall Configuration
    firewall = {
      enable = true;

      # KDE Connect Port Ranges
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

      # Trust Tailscale mesh interface traffic
      trustedInterfaces = [ "tailscale0" ];
    };
  };
}