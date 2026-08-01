{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [

    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    waypaper
    awww
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    pamixer
    brightnessctl

    zoxide
    fzf
    bat
    btop
    lazygit
    ghostty
    alacritty
    kitty

    vscode

    obsidian
    mpv
    vlc
    vesktop

    pkgs.thunar
    pkgs.thunar-archive-plugin
    pkgs.thunar-volman

    loupe

    file-roller
  ];
}