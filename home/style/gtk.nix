{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # GTK Config
  # -------------------------------------------------------------------------
  # font, iconTheme, and cursorTheme used to be set here — all three are
  # now owned by Stylix instead (../style/stylix.nix: stylix.fonts,
  # stylix.iconTheme, stylix.cursor / home.pointerCursor via the cursor
  # target). Setting them in both places would fight over the same
  # options, so only the dark-mode preference (not a color, just a
  # flag Stylix doesn't touch) stays here.
  gtk = {
    enable = true;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
