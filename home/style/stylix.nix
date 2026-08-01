{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Stylix — wallpaper-derived, system-wide theming
  # -------------------------------------------------------------------------
  # Stylix is enabled at the NixOS level too (stylix.nixosModules.stylix,
  # see ../../flake.nix), which auto-detects that home-manager is running
  # as a NixOS module and wires up its Home Manager integration for us —
  # nothing extra needed here for that part.
  #
  # IMPORTANT — how "dynamic" actually works here, since this is a real
  # difference from the old matugen setup: Stylix computes the color
  # scheme from `stylix.image` below at BUILD time, as a Nix derivation.
  # There is no live "reapply on wallpaper change" the way matugen's
  # activation-hook trick gave us — changing your wallpaper via waypaper
  # changes what's *displayed*, but every themed app keeps its colors
  # from whatever image `stylix.image` currently points at, until you
  # edit this file and run `nixos-rebuild switch` again. If you want the
  # theme to actually follow a new wallpaper, update the path below to
  # point at the new image and rebuild — there's no way around a rebuild
  # with Stylix; that's the tradeoff for it owning far more targets than
  # matugen did with much less manual template-writing.
  stylix = {
    enable = true;

    # Nix-store-relative path so it's a real build input, not a runtime
    # `~` path (which stylix.image can't consume — it needs something
    # that exists at evaluation time). Points at the same wallpaper the
    # old matugen setup defaulted to.
    image = ../../assets/wallpapers/6.png;

    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    # Targets confirmed to exist in Stylix's module list. autoEnable
    # defaults to true for installed targets anyway — these are just
    # explicit for clarity/documentation.
    targets = {
      kitty.enable = true;
      alacritty.enable = true;
      gtk.enable = true;
      qt.enable = true;
      starship.enable = true;
      # niri.enable is set via niri-flake's own Stylix integration
      # (home/desktop/niri.nix), not this module — see the comment
      # there for why.
    };
  };

  # NOTE on Ghostty and fastfetch: as of this writing, Stylix has no
  # confirmed native target for either. Rather than guess at option
  # names I can't verify, both are hand-wired directly to
  # config.lib.stylix.colors.withHashtag in their own files
  # (../apps/editor.nix for Ghostty, ../apps/fastfetch.nix) — Stylix's
  # own documented mechanism for "targets it doesn't natively support."
  # Same story for Neovim's colorscheme (../apps/neovim.nix) and
  # Starship's exact palette values (../apps/starship.nix), even though
  # starship has a native target — hand-wiring gives predictable control
  # over which base16 slot maps to which UI element instead of trusting
  # an unverified default mapping.
}
