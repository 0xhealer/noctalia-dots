{ pkgs, config, inputs, lib, ... }:

{
  programs.niri = { 
    # Settings configuration
    settings = {
      # Input Settings
      input = {
        keyboard.xkb = {
          layout = "us";
        };
        touchpad = {
          tap = true;
          drag = true;
          natural-scroll = true;
        };
        mouse = {
          natural-scroll = false;
        };
      };

      # Output & Display Layout
      outputs = {
        # Configure primary monitor if needed, e.g.:
        # "eDP-1" = { scale = 1.0; position x=0 y=0; };
      };

      # Window Layout & Appearance
      layout = {
        gaps = 12;
        center-focused-column = "never";
        
        default-column-width = {
          proportion = 0.5;
        };
        
        focus-ring = {
          enable = true;
          width = 2;
          active.color = lib.mkForce "#7aa2f7";
          inactive.color = lib.mkForce "#414868";
        };

        border = {
          enable = false;
        };

        # "Option 2: Stationary Wallpaper" from Noctalia's niri docs —
        # since awww/waypaper already own the wallpaper (Noctalia's own
        # wallpaper.enabled is set to false in ./noctalia.nix), keep the
        # workspace background transparent so it stays visible everywhere.
        background-color = "transparent";
      };

      overview = {
        workspace-shadow.enable = false;
      };

      # Noctalia-recommended window/layer rules
      # https://docs.noctalia.dev/v5/compositor-settings/niri/
      window-rules = [
        {
          # Rounded corners for a modern look; clip contents to match.
          # This field is a submodule (per-corner), not a bare number —
          # niri-flake's schema mirrors niri's raw KDL leaf args here
          # (geometry-corner-radius top-left=… top-right=… etc.).
          geometry-corner-radius = {
            top-left = 20.0;
            top-right = 20.0;
            bottom-left = 20.0;
            bottom-right = 20.0;
          };
          clip-to-geometry = true;
        }
        {
          # Floating Noctalia settings window.
          matches = [ { app-id = "^dev\\.noctalia\\.Noctalia$"; } ];
          open-floating = true;
          default-column-width.fixed = 1080;
          default-window-height.fixed = 920;
        }
      ];

      layer-rules = [
        {
          # Pin the (now stationary) wallpaper layer behind the overview.
          matches = [ { namespace = "^noctalia-wallpaper"; } ];
          place-within-backdrop = true;
        }
      ];

      # -----------------------------------------------------------------
      # Blur — intentionally NOT enabled.
      # -----------------------------------------------------------------
      # Noctalia's own docs are explicit that blur support landed in niri
      # 26.04 (docs.noctalia.dev/v5/compositor-settings/niri/#blur), and
      # this flake's `pkgs.niri-stable` (what `programs.niri.package`
      # uses by default — see ../../flake.nix) is pinned to niri 25.08.
      # `background-effect`/a top-level `blur` block on an older niri
      # either don't exist in the schema or get rejected by `niri
      # validate` at build time — not a naming typo to fix, a genuine
      # version gap. Transparency (GTK CSS alpha, terminal
      # background-opacity, fuzzel alpha) is untouched by this and still
      # works today; only the compositor-side blur-behind-windows effect
      # is affected.
      #
      # To enable it once you're on niri >= 26.04 (e.g. by setting
      # `programs.niri.package = pkgs.niri-unstable;`, using the
      # `niri.overlays.niri` overlay), uncomment this block and merge it
      # into window-rules/layer-rules above:
      #
      # window-rules extra entry:
      #   { background-effect = { blur = true; xray = false; }; }
      # layer-rules extra entries:
      #   {
      #     matches = [ { namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"; } ];
      #     background-effect.xray = false;
      #   }
      #   {
      #     matches = [ { namespace = "noctalia-window-switcher"; } ];
      #     background-effect = { blur = true; xray = false; };
      #   }
      # top-level:
      #   blur = { passes = 2; offset = 3.0; noise = 0.03; saturation = 1.0; };

      debug = {
        # Allows notification actions and window activation from Noctalia.
        honor-xdg-activation-with-invalid-serial = true;
      };

      # Autostart Programs
      spawn-at-startup = [
        { command = [ "awww-daemon" ]; }
        { command = [ "waypaper" "--restore" ]; }
        { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }
        # Launches the Noctalia shell (bar, launcher, notifications,
        # control center, etc.) at session start.
        { command = [ "noctalia" ]; }
      ];

      # Keybindings
      binds = with config.lib.niri.actions; {
        # Applications & Utilities
        "Mod+Return".action = spawn "ghostty";
        "Mod+Shift+Return".action = spawn "kitty";
        "Mod+B".action = spawn "zen";
        "Mod+E".action = spawn "thunar";
        "Mod+Shift+D".action = spawn "fuzzel"; # Backup launcher, Noctalia's is on Mod+Space

        # Screenshots (grim + slurp + swappy)
        "Print".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -";
        "Shift+Print".action = spawn "sh" "-c" "grim ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png";

        # Noctalia IPC — core panels
        # https://docs.noctalia.dev/v5/compositor-settings/niri/
        "Mod+Space".action = spawn "noctalia" "msg" "panel-toggle" "launcher";
        "Mod+S".action = spawn "noctalia" "msg" "panel-toggle" "control-center";
        "Mod+Comma".action = spawn "noctalia" "msg" "settings-toggle";
        "Alt+Tab".action = spawn "noctalia" "msg" "window-switcher";

        # Audio & Brightness — routed through Noctalia so its OSD/UI
        # stays in sync with the actual state.
        "XF86AudioRaiseVolume".action = spawn "noctalia" "msg" "volume-up";
        "XF86AudioLowerVolume".action = spawn "noctalia" "msg" "volume-down";
        "XF86AudioMute".action = spawn "noctalia" "msg" "volume-mute";
        "XF86MonBrightnessUp".action = spawn "noctalia" "msg" "brightness-up";
        "XF86MonBrightnessDown".action = spawn "noctalia" "msg" "brightness-down";

        # Window & Column Management
        "Mod+Q".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        # Focus Navigation
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Up".action = focus-window-up;
        "Mod+Down".action = focus-window-down;
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-window-up;
        "Mod+J".action = focus-window-down;

        # Move Columns / Windows
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;

        # Column Resizing
        "Mod+R".action = switch-preset-column-width;
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";

        # Workspace Management
        "Mod+1".action = focus-workspace 1;
  "Mod+2".action = focus-workspace 2;
  "Mod+3".action = focus-workspace 3;
  "Mod+4".action = focus-workspace 4;
  "Mod+Shift+1".action.move-column-to-workspace = [ 1 ];
  "Mod+Shift+2".action.move-column-to-workspace = [ 2 ];
  "Mod+Shift+3".action.move-column-to-workspace = [ 3 ];
  "Mod+Shift+4".action.move-column-to-workspace = [ 4 ];

        # System Controls
        "Mod+Shift+E".action = quit;
      };

      # Laptop-only: lock + suspend on lid close, routed through Noctalia.
      # Uncomment if this machine is a laptop (also set HandleLidSwitch and
      # HandleLidSwitchExternalPower to "ignore" in logind.conf so systemd
      # doesn't race Noctalia for the lid event).
      # switch-events.lid-close.action = spawn "noctalia" "msg" "session" "lock-and-suspend";
    };
  };
}