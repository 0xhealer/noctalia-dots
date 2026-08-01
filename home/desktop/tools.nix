{ pkgs, ... }:

{
  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=sans-serif
  '';

  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    language = en
    folder = ~/.local/share/noctalia-dots/assets/wallpapers
    wallpaper = ~/.local/share/noctalia-dots/assets/wallpapers/6.png
    backend = awww
    fill = fill
    sort = name
    subfolders = False
    number_of_columns = 3
    # NOTE: no post_command here anymore. The old `matugen image
    # $wallpaper` trigger doesn't apply — Stylix (../style/stylix.nix)
    # computes colors at build time from stylix.image, not live from
    # whichever wallpaper waypaper currently has selected. Changing the
    # wallpaper here only changes what's displayed; to actually re-theme
    # the desktop, update stylix.image to point at the new file and run
    # `nixos-rebuild switch`.
    swww_transition_type = outer
    swww_transition_step = 90
    swww_transition_angle = 30
    swww_transition_duration = 2
    swww_transition_fps = 60
  '';
}