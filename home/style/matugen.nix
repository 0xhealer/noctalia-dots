{ pkgs, lib, ... }:

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

    # 2. GTK3 Colors + Transparency
    [templates.gtk3_colors]
    input_path = '~/.config/matugen/templates/colors.css'
    output_path = '~/.config/gtk-3.0/gtk.css'

    # 3. GTK4 Colors + Transparency (libadwaita apps, Nautilus-likes, etc.)
    [templates.gtk4_colors]
    input_path = '~/.config/matugen/templates/colors.css'
    output_path = '~/.config/gtk-4.0/gtk.css'

    # 4. Fuzzel Application Launcher
    [templates.fuzzel]
    input_path = '~/.config/matugen/templates/fuzzel.ini'
    output_path = '~/.config/fuzzel/colors.ini'

    # 5. Alacritty Terminal Colors
    [templates.alacritty]
    input_path = '~/.config/matugen/templates/alacritty.toml'
    output_path = '~/.config/alacritty/colors.toml'

    # 6. Kitty Terminal Colors
    [templates.kitty]
    input_path = '~/.config/matugen/templates/kitty.conf'
    output_path = '~/.config/kitty/colors.conf'

    # 7. Starship Prompt
    [templates.starship]
    input_path = '~/.config/matugen/templates/starship.toml'
    output_path = '~/.config/starship.toml'

    # 8. Fastfetch
    [templates.fastfetch]
    input_path = '~/.config/matugen/templates/fastfetch.jsonc'
    output_path = '~/.config/fastfetch/config.jsonc'

    # 9. Neovim (base16-nvim palette, loaded by ../apps/neovim.nix)
    [templates.nvim]
    input_path = '~/.config/matugen/templates/nvim-colors.lua'
    output_path = '~/.config/nvim/matugen-colors.lua'
  '';

  # NOTE on Niri: there is intentionally no matugen template targeting
  # niri here. Niri's config (including the focus-ring colors set in
  # ./niri.nix) is generated at build time from home/desktop/niri.nix —
  # it has no mechanism to hot-reload an external "colors.kdl" file
  # produced at runtime, so a template for it would silently do nothing.
  # If you want the focus ring to follow your wallpaper, update the hex
  # values in home/desktop/niri.nix and rebuild.
  #
  # NOTE on VS Code / Spicetify: these already use a static transparent
  # theme (see ../apps/vscode.nix and ../style/spicetify.nix) rather than
  # a matugen template, since VS Code has no built-in mechanism to
  # hot-reload colors from an external file without a marketplace
  # extension. They stay visually consistent (transparent, blur-friendly)
  # but won't shift hue with the wallpaper like the apps below do.

  # -------------------------------------------------------------------------
  # Template Files
  # -------------------------------------------------------------------------

  # GTK3/4 CSS Template — palette variables + real transparency, so
  # GTK windows (Thunar, etc.) are ready to let niri's blur show through
  # once it's enabled (see the note in ../desktop/niri.nix).
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

    /* Transparency — ready for niri's blur once it's enabled (see the
       commented-out block in ../desktop/niri.nix; niri-stable here is
       pinned below the 26.04 version blur requires) */
    window,
    .background {
      background-color: alpha(@background, 0.85);
    }

    headerbar,
    .titlebar {
      background-color: alpha(@surface, 0.85);
    }
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

  # Starship Prompt Template — same structure/symbols as before, colors
  # swapped for matugen tokens. Kept in sync with ../apps/starship.nix.
  xdg.configFile."matugen/templates/starship.toml".text = ''
    # FIRST LINE/ROW: Info & Status
    [username]
    format = "[힐러](bold {{colors.primary.default.hex}}) @ "
    show_always = true
    style_root = "bold {{colors.error.default.hex}}"

    [hostname]
    disabled = false
    format = "[판도라](bold {{colors.secondary.default.hex}}) in "
    ssh_only = false
    ssh_symbol = " "

    [directory]
    style = "bold {{colors.tertiary.default.hex}}"
    truncate_to_repo = true
    truncation_length = 0
    truncation_symbol = "레포: "
    read_only = ""

    [git_metrics]
    disabled = false
    added_style = "bold {{colors.tertiary.default.hex}}"
    format = "[+$added]($added_style)/[-$deleted]($deleted_style) "

    [sudo]
    disabled = false

    [git_status]
    ahead = "''${count}"
    behind = "''${count}"
    deleted = "x"
    diverged = "''${ahead_count}''${behind_count}"
    style = "text"

    [git_branch]
    symbol = " "
    style = "bold {{colors.tertiary.default.hex}}"

    [nix_shell]
    format = "via [$symbol(($name))]($style) "
    symbol = " "

    [cmd_duration]
    disabled = false
    style = "bold {{colors.primary_container.default.hex}}"
    format = "took [$duration]($style)"
    show_milliseconds = true
    show_notifications = true
    min_time_to_notify = 30000

    # SECOND LINE/ROW: Prompt
    [battery]
    charging_symbol = ""
    disabled = true
    discharging_symbol = ""
    full_symbol = ""

    [[battery.display]]
    disabled = false
    style = "bold {{colors.error.default.hex}}"
    threshold = 15

    [[battery.display]]
    disabled = true
    style = "bold {{colors.secondary.default.hex}}"
    threshold = 50

    [[battery.display]]
    disabled = true
    style = "bold {{colors.tertiary.default.hex}}"
    threshold = 90

    [status]
    disabled = false
    format = "[$symbol$status_common_meaning$status_signal_name$status_maybe_int]($style)"
    map_symbol = true
    pipestatus = true
    symbol = "✖"
    not_executable_symbol = ""
    not_found_symbol = ""
    sigint_symbol = "󰟾"
    signal_symbol = ""

    [os]
    disabled = false
    format = " [$symbol]($style)"
    style = "bold {{colors.primary.default.hex}}"

    [os.symbols]
    Alpaquita = " "
    Alpine = " "
    AlmaLinux = " "
    Amazon = " "
    Android = " "
    Arch = " "
    Artix = " "
    CentOS = " "
    Debian = " "
    DragonFly = " "
    Emscripten = " "
    EndeavourOS = " "
    Fedora = " "
    FreeBSD = " "
    Garuda = "󰛓 "
    Gentoo = " "
    HardenedBSD = "󰞌 "
    Illumos = "󰈸 "
    Kali = " "
    Linux = " "
    Mabox = " "
    Macos = " "
    Manjaro = " "
    Mariner = " "
    MidnightBSD = " "
    Mint = " "
    NetBSD = " "
    NixOS = " "
    OpenBSD = "󰈺 "
    openSUSE = " "
    OracleLinux = "󰌷 "
    Pop = " "
    Raspbian = " "
    Redhat = " "
    RedHatEnterprise = " "
    RockyLinux = " "
    Redox = "󰀘 "
    Solus = "󰠳 "
    SUSE = " "
    Ubuntu = " "
    Unknown = " "
    Void = " "
    Windows = "󰍲 "

    [character]
    error_symbol = ""
    success_symbol = "[❯](bold {{colors.tertiary.default.hex}})"

    # Language & Tool Symbols
    [git_commit]
    tag_symbol = "  "

    [golang]
    symbol = " "
    [guix_shell]
    symbol = " "
    [haskell]
    symbol = " "
    [haxe]
    symbol = " "
    [hg_branch]
    symbol = " "
    [java]
    symbol = " "
    [julia]
    symbol = " "
    [kotlin]
    symbol = " "
    [lua]
    symbol = " "
    [memory_usage]
    symbol = "󰍛 "
    [meson]
    symbol = "󰔷 "
    [nim]
    symbol = "󰆥 "
    [nodejs]
    symbol = " "
    [ocaml]
    symbol = " "
    [package]
    symbol = "󰏗 "
    [perl]
    symbol = " "
    [php]
    symbol = " "
    [pijul_channel]
    symbol = " "
    [python]
    symbol = " "
    [rlang]
    symbol = "󰟔 "
    [ruby]
    symbol = " "
    [rust]
    symbol = "󱘗 "
    [scala]
    symbol = " "
    [swift]
    symbol = " "
    [zig]
    symbol = " "
    [gradle]
    symbol = " "
  '';

  # Fastfetch Template — same modules/logo as before, key/title colors
  # now pull from matugen.
  xdg.configFile."matugen/templates/fastfetch.jsonc".text = ''
    {
      "logo": {
        "type": "kitty-direct",
        "source": "~/.local/share/noctalia-dots/assets/fastfetch/logo.png",
        "width": 28,
        "height": 12,
        "padding": { "top": 1, "left": 2 }
      },
      "display": {
        "separator": " ➜ ",
        "color": {
          "keys": "{{colors.primary.default.hex}}",
          "title": "{{colors.tertiary.default.hex}}"
        }
      },
      "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "wm",
        "terminal",
        "cpu",
        "gpu",
        "memory",
        "break",
        "colors"
      ]
    }
  '';

  # Neovim Template — base16 palette consumed by ../apps/neovim.nix
  xdg.configFile."matugen/templates/nvim-colors.lua".text = ''
    return {
      base00 = "{{colors.background.default.hex}}",
      base01 = "{{colors.surface.default.hex}}",
      base02 = "{{colors.primary_container.default.hex}}",
      base03 = "{{colors.outline.default.hex}}",
      base04 = "{{colors.outline.default.hex}}",
      base05 = "{{colors.on_background.default.hex}}",
      base06 = "{{colors.on_surface.default.hex}}",
      base07 = "{{colors.on_primary_container.default.hex}}",
      base08 = "{{colors.error.default.hex}}",
      base09 = "{{colors.secondary.default.hex}}",
      base0A = "{{colors.secondary.default.hex}}",
      base0B = "{{colors.tertiary.default.hex}}",
      base0C = "{{colors.outline.default.hex}}",
      base0D = "{{colors.primary.default.hex}}",
      base0E = "{{colors.primary_container.default.hex}}",
      base0F = "{{colors.on_primary.default.hex}}",
    }
  '';

  # -------------------------------------------------------------------------
  # Auto-reapply on every rebuild
  # -------------------------------------------------------------------------
  # Every output above (terminal colors, starship.toml, fastfetch config,
  # the nvim palette, GTK CSS...) lives outside the Nix store on purpose,
  # so matugen can rewrite it live when you change wallpapers. The catch:
  # `nixos-rebuild switch` re-links every xdg.configFile target on each
  # run, which would silently wipe those live colors back to the day-one
  # fallback below until you next touch your wallpaper. This activation
  # hook reruns matugen against whatever wallpaper waypaper currently has
  # configured, right after every switch, so the real palette is restored
  # automatically instead of you needing to reset the wallpaper by hand.
  home.activation.reapplyMatugen = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    WP_CONFIG="$HOME/.config/waypaper/config.ini"
    if [ -f "$WP_CONFIG" ]; then
      WALLPAPER="$(${pkgs.gnugrep}/bin/grep -m1 '^wallpaper' "$WP_CONFIG" 2>/dev/null \
        | ${pkgs.gnused}/bin/sed -e 's/^wallpaper *= *//' -e "s|^~|$HOME|")"
      if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
        $DRY_RUN_CMD ${pkgs.matugen}/bin/matugen image "$WALLPAPER" || true
      fi
    fi
  '';

  # -------------------------------------------------------------------------
  # Day-one fallback colors
  # -------------------------------------------------------------------------
  # Belt-and-suspenders for the very first activation, in case the hook
  # above can't find a wallpaper yet (e.g. bootstrap.sh hasn't finished
  # cloning the wallpapers directory). A Catppuccin Mocha palette,
  # matching the "Catppuccin" theme picked in ../desktop/noctalia.nix.
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

  # mkForce: guards against home-manager's own starship module also
  # trying to write this same path (harmless if it doesn't — this just
  # makes the fallback win deterministically instead of a build conflict).
  xdg.configFile."starship.toml".text = lib.mkForce ''
    [username]
    format = "[힐러](bold #89b4fa) @ "
    show_always = true
    style_root = "bold #f38ba8"

    [hostname]
    disabled = false
    format = "[판도라](bold #f5c2e7) in "
    ssh_only = false
    ssh_symbol = " "

    [directory]
    style = "bold #a6e3a1"
    truncate_to_repo = true
    truncation_length = 0
    truncation_symbol = "레포: "
    read_only = ""

    [character]
    error_symbol = ""
    success_symbol = "[❯](bold #a6e3a1)"
  '';

  # mkForce: same reasoning as starship.toml above.
  xdg.configFile."fastfetch/config.jsonc".text = lib.mkForce ''
    {
      "logo": {
        "type": "kitty-direct",
        "source": "~/.local/share/noctalia-dots/assets/fastfetch/logo.png",
        "width": 28,
        "height": 12,
        "padding": { "top": 1, "left": 2 }
      },
      "display": {
        "separator": " ➜ ",
        "color": { "keys": "#89b4fa", "title": "#a6e3a1" }
      },
      "modules": [
        "title", "separator", "os", "host", "kernel", "uptime",
        "packages", "shell", "wm", "terminal", "cpu", "gpu", "memory",
        "break", "colors"
      ]
    }
  '';

  xdg.configFile."nvim/matugen-colors.lua".text = ''
    return {
      base00 = "#1e1e2e", base01 = "#313244", base02 = "#45475a",
      base03 = "#6c7086", base04 = "#6c7086", base05 = "#cdd6f4",
      base06 = "#cdd6f4", base07 = "#cdd6f4", base08 = "#f38ba8",
      base09 = "#f5c2e7", base0A = "#f5c2e7", base0B = "#a6e3a1",
      base0C = "#6c7086", base0D = "#89b4fa", base0E = "#45475a",
      base0F = "#1e1e2e",
    }
  '';
}
