{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Package Installation
  # -------------------------------------------------------------------------
  home.packages = with pkgs; [
    matugen
  ];

  # -------------------------------------------------------------------------
  # Matugen Master Configuration (~/.config/matugen/config.toml)
  # -------------------------------------------------------------------------
  xdg.configFile."matugen/config.toml".text = ''
    [config]
    wallpaper_tool = "Swww"

    [config.wallpaper]
    command = "swww img --transition-type outer --transition-fps 60"

    # --- Target Templates ---

    # 1. Ghostty Terminal Colors
    [templates.ghostty]
    input_path = '~/.config/matugen/templates/ghostty'
    output_path = '~/.config/ghostty/themes/matugen'

    # 2. GTK / CSS Variables (Wayland bars, Noctalia, SwayNC)
    [templates.gtk_colors]
    input_path = '~/.config/matugen/templates/colors.css'
    output_path = '~/.config/gtk-3.0/gtk.css'

    # 3. Fuzzel Application Launcher
    [templates.fuzzel]
    input_path = '~/.config/matugen/templates/fuzzel.ini'
    output_path = '~/.config/fuzzel/colors.ini'

    # 4. Niri Focus Ring / Window Accent Colors
    [templates.niri]
    input_path = '~/.config/matugen/templates/niri.kdl'
    output_path = '~/.config/niri/colors.kdl'
  '';

  # -------------------------------------------------------------------------
  # Template Files
  # -------------------------------------------------------------------------

  # GTK / CSS Template
  xdg.configFile."matugen/templates/colors.css".text = ''
    @define-color primary {{colors.primary.default.hex}};
    @define-color on_primary {{colors.on_primary.default.hex}};
    @define-color primary_container {{colors.primary_container.default.hex}};
    @define-color on_primary_container {{colors.on_primary_container.default.hex}};
    @define-color surface {{colors.surface.default.hex}};
    @define-color on_surface {{colors.on_surface.default.hex}};
    @define-color background {{colors.background.default.hex}};
    @define-color on_background {{colors.on_background.default.hex}};
    @define-color error {{colors.error.default.hex}};
    @define-color outline {{colors.outline.default.hex}};
  '';

  # Ghostty Terminal Template
  xdg.configFile."matugen/templates/ghostty".text = ''
    background = {{colors.background.default.hex}}
    foreground = {{colors.on_background.default.hex}}
    cursor-color = {{colors.primary.default.hex}}
    
    palette = 0={{colors.surface.default.hex}}
    palette = 1={{colors.error.default.hex}}
    palette = 2={{colors.primary.default.hex}}
    palette = 3={{colors.tertiary.default.hex}}
    palette = 4={{colors.secondary.default.hex}}
    palette = 5={{colors.primary_container.default.hex}}
    palette = 6={{colors.outline.default.hex}}
    palette = 7={{colors.on_surface.default.hex}}
  '';

  # Fuzzel Launcher Template (Feeds directly into shell.nix include)
  xdg.configFile."matugen/templates/fuzzel.ini".text = ''
    [colors]
    background={{colors.surface.default.hex strip}}dd
    text={{colors.on_surface.default.hex strip}}ff
    match={{colors.primary.default.hex strip}}ff
    selection={{colors.primary_container.default.hex strip}}ff
    selection-text={{colors.on_primary_container.default.hex strip}}ff
    border={{colors.primary.default.hex strip}}ff
  '';

  # Niri Border & Accent Template
  xdg.configFile."matugen/templates/niri.kdl".text = ''
    layout {
      focus-ring {
        active-color "{{colors.primary.default.hex}}"
        inactive-color "{{colors.surface.default.hex}}"
      }
    }
  '';
}