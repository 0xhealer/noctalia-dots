{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Fastfetch System Information Tool
  # -------------------------------------------------------------------------
  # NOTE: the module list/logo/display settings used to live in `settings`
  # below (static, rebuild-time only). The whole config is now generated
  # by Matugen instead (~/.config/matugen/templates/fastfetch.jsonc ->
  # ~/.config/fastfetch/config.jsonc, see ../style/matugen.nix) so its key
  # colors follow your wallpaper along with everything else — no
  # `settings` block here to avoid two systems fighting over the same file.
  programs.fastfetch = {
    enable = true;
  };
}
