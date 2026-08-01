{ pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [ "https://noctalia.cachix.org" ];
    trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  environment.systemPackages = with pkgs; [

    git
    curl
    wget
    ripgrep
    fd
    tree
    fish
    gcc
    gnumake
    eza
    fastfetch
    unzip
    nixd
    nixfmt-rfc-style
    lua-language-server
    stylua
    p7zip

    pciutils
    usbutils
    playerctl
    lm_sensors
    brightnessctl
    networkmanagerapplet
    blueman
    pavucontrol

    wireplumber
    wl-clipboard

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}