{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true; # default shell is fish (see apps/shell.nix)

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "alphabetical";
        sort_dir_first = true;
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "application/x-gnome-saved-search" = [ "thunar.desktop" ];
    };
  };
}