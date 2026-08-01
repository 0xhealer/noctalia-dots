{ pkgs, ... }:

{

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting
    '';

    shellAliases = {

      ls = "eza --icons";
      ll = "eza -la --icons";
      tree = "eza --tree --icons";
      cat = "bat";
      cd = "z";

      ff = "fastfetch";
      lg = "lazygit";

      rebuild = "sudo nixos-rebuild switch --flake ~/.local/share/noctalia-dots#nixos";
      ncg = "nix-collect-garbage -d";
    };
  };

  programs.zoxide.enableFishIntegration = true;
  programs.eza.enableFishIntegration = true;
}