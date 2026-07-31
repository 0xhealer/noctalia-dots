{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Custom Flake Input Packages
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    loupe
    vesktop

    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman

    # Image Viewer for Quick Previews
    loupe

    # Archive utilities for GUI file manager context menus
    file-roller
  ];
}