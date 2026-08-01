{ pkgs, ... }:

{

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  services.fstrim.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
}