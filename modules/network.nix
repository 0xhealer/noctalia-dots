{ pkgs, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "9.9.9.9"];

    firewall = {
      enable = true;

      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

      trustedInterfaces = [ "tailscale0" ];
    };
  };
}