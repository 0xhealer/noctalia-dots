{ pkgs, ... }:

{
  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;

  # Noctalia's binary cache. Without this, Noctalia's Qt/C++/Rust shell
  # compiles from source on every rebuild — very slow on a resource-capped
  # machine (e.g. a VM). Paired with dropping noctalia.inputs.nixpkgs.follows
  # in flake.nix, which is required for the cache to actually be usable
  # (see docs.noctalia.dev/v5/getting-started/nixos/).
  nix.settings = {
    substituters = [ "https://noctalia.cachix.org" ];
    trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  # Core System Packages
  environment.systemPackages = with pkgs; [
    # Core CLI Utilities
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

    # Hardware & System Info Tools
    pciutils
    usbutils
    playerctl
    lm_sensors
    brightnessctl
    networkmanagerapplet
    blueman
    pavucontrol

    # Sound & Wayland Utilities
    wireplumber
    wl-clipboard

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}