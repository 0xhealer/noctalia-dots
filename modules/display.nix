{ pkgs, ... }:

{
  # SDDM Display Manager with Wayland Enabled
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable Polkit Security Framework
  security.polkit.enable = true;

  # KDE Polkit Graphical Authentication Agent (for Niri privilege popups)
  systemd.user.services.polkit-kde-authentication-agent-1 = {
    description = "KDE Polkit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}