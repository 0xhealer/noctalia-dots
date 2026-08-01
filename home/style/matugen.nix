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

    # 4. Alacritty Terminal Colors
    [templates.alacritty]
    input_path = '~/.config/matugen/templates/alacritty.toml'
    output_path = '~/.config/alacritty/colors.toml'

    # 5. Kitty Terminal Colors
    [templates.kitty]
    input_path = '~/.config/matugen/templates/kitty.conf'
    output_path = '~/.config/kitty/colors.conf'
  '';

  # NOTE on Niri: there is intentionally no matugen template targeting
  # niri here. Niri's config (including the focus-ring colors set in
  # ./niri.nix) is generated at build time from home/desktop/niri.nix —
  # it has no mechanism to hot-reload an external "colors.kdl" file
  # produced at runtime, so a template for it would silently do nothing.
  # If you want the focus ring to follow your wallpaper, update the hex
  # values in home/desktop/niri.nix and rebuild.

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

  # Alacritty Terminal Template (TOML — imported via general.import)
  xdg.configFile."matugen/templates/alacritty.toml".text = ''
    [colors.primary]
    background = "{{colors.background.default.hex}}"
    foreground = "{{colors.on_background.default.hex}}"

    [colors.cursor]
    text = "{{colors.background.default.hex}}"
    cursor = "{{colors.primary.default.hex}}"

    [colors.normal]
    black = "{{colors.surface.default.hex}}"
    red = "{{colors.error.default.hex}}"
    green = "{{colors.tertiary.default.hex}}"
    yellow = "{{colors.secondary.default.hex}}"
    blue = "{{colors.primary.default.hex}}"
    magenta = "{{colors.primary_container.default.hex}}"
    cyan = "{{colors.outline.default.hex}}"
    white = "{{colors.on_surface.default.hex}}"

    [colors.bright]
    black = "{{colors.outline.default.hex}}"
    red = "{{colors.error.default.hex}}"
    green = "{{colors.tertiary.default.hex}}"
    yellow = "{{colors.secondary.default.hex}}"
    blue = "{{colors.primary.default.hex}}"
    magenta = "{{colors.primary_container.default.hex}}"
    cyan = "{{colors.outline.default.hex}}"
    white = "{{colors.on_background.default.hex}}"
  '';

  # Kitty Terminal Template (kitty.conf syntax — included via extraConfig)
  xdg.configFile."matugen/templates/kitty.conf".text = ''
    background {{colors.background.default.hex}}
    foreground {{colors.on_background.default.hex}}
    cursor {{colors.primary.default.hex}}

    color0  {{colors.surface.default.hex}}
    color1  {{colors.error.default.hex}}
    color2  {{colors.tertiary.default.hex}}
    color3  {{colors.secondary.default.hex}}
    color4  {{colors.primary.default.hex}}
    color5  {{colors.primary_container.default.hex}}
    color6  {{colors.outline.default.hex}}
    color7  {{colors.on_surface.default.hex}}
    color8  {{colors.outline.default.hex}}
    color9  {{colors.error.default.hex}}
    color10 {{colors.tertiary.default.hex}}
    color11 {{colors.secondary.default.hex}}
    color12 {{colors.primary.default.hex}}
    color13 {{colors.primary_container.default.hex}}
    color14 {{colors.outline.default.hex}}
    color15 {{colors.on_background.default.hex}}
  '';

  # -------------------------------------------------------------------------
  # Day-one fallback colors
  # -------------------------------------------------------------------------
  # The files above are matugen's *input* templates; the actual colors
  # (~/.config/ghostty/themes/matugen, .../fuzzel/colors.ini, .../alacritty/
  # colors.toml, .../kitty/colors.conf) only get generated once matugen
  # runs — which happens via waypaper's post_command (see ./tools.nix)
  # after a wallpaper is set. On a brand new install those files don't
  # exist yet, which would otherwise make Ghostty/Alacritty/Kitty/Fuzzel
  # fail to start. These home-manager-written fallbacks (a Catppuccin
  # Mocha palette, matching the "Catppuccin" theme picked in
  # ../desktop/noctalia.nix) plug that gap; matugen freely overwrites
  # them the first time it runs.
  xdg.configFile."ghostty/themes/matugen".text = ''
    background = 1e1e2e
    foreground = cdd6f4
    cursor-color = 89b4fa

    palette = 0=313244
    palette = 1=f38ba8
    palette = 2=89b4fa
    palette = 3=a6e3a1
    palette = 4=f5c2e7
    palette = 5=45475a
    palette = 6=6c7086
    palette = 7=cdd6f4
  '';

  xdg.configFile."fuzzel/colors.ini".text = ''
    [colors]
    background=313244dd
    text=cdd6f4ff
    match=89b4faff
    selection=45475aff
    selection-text=cdd6f4ff
    border=89b4faff
  '';

  xdg.configFile."alacritty/colors.toml".text = ''
    [colors.primary]
    background = "#1e1e2e"
    foreground = "#cdd6f4"

    [colors.cursor]
    text = "#1e1e2e"
    cursor = "#89b4fa"

    [colors.normal]
    black = "#313244"
    red = "#f38ba8"
    green = "#a6e3a1"
    yellow = "#f5c2e7"
    blue = "#89b4fa"
    magenta = "#45475a"
    cyan = "#6c7086"
    white = "#cdd6f4"

    [colors.bright]
    black = "#6c7086"
    red = "#f38ba8"
    green = "#a6e3a1"
    yellow = "#f5c2e7"
    blue = "#89b4fa"
    magenta = "#45475a"
    cyan = "#6c7086"
    white = "#cdd6f4"
  '';

  xdg.configFile."kitty/colors.conf".text = ''
    background 1e1e2e
    foreground cdd6f4
    cursor 89b4fa

    color0  313244
    color1  f38ba8
    color2  a6e3a1
    color3  f5c2e7
    color4  89b4fa
    color5  45475a
    color6  6c7086
    color7  cdd6f4
    color8  6c7086
    color9  f38ba8
    color10 a6e3a1
    color11 f5c2e7
    color12 89b4fa
    color13 45475a
    color14 6c7086
    color15 cdd6f4
  '';
}