{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Custom Flake Input Packages
    # NOTE: Noctalia itself is installed declaratively by its Home Manager
    # module (programs.noctalia.enable, see ./desktop/noctalia.nix) — that
    # module pulls in the package for us, so it isn't listed here.
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Wayland, Theming & Desktop Utilities
    waypaper
    swww
    matugen
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    pamixer
    brightnessctl

    # Modern CLI & Terminal Enhancements
    zoxide
    fzf 
    bat
    btop
    lazygit
    ghostty
    alacritty
    kitty

    # User GUI Applications, Productivity & Media
    vscode
    obsidian
    spotify
    mpv
    vlc
    vesktop

    pkgs.thunar
    pkgs.thunar-archive-plugin
    pkgs.thunar-volman

    # Image Viewer for Quick Previews
    loupe

    # Archive utilities for GUI file manager context menus
    file-roller
  ];
}