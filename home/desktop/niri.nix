{ pkgs, config, inputs, lib, ... }:

{

  stylix.targets.niri.enable = true;

  programs.niri = {
    enable = true;

    settings = {

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

      outputs = {

      };

      layout = {
        gaps = 12;
        center-focused-column = "never";

        default-column-width = {
          proportion = 0.5;
        };

        focus-ring = {
          enable = true;
          width = 2;
        };

        border = {
          enable = false;
        };

        background-color = "transparent";
      };

      overview = {
        workspace-shadow.enable = false;
      };

      window-rules = [
        {

          geometry-corner-radius = {
            top-left = 20.0;
            top-right = 20.0;
            bottom-left = 20.0;
            bottom-right = 20.0;
          };
          clip-to-geometry = true;
        }
        {

          matches = [ { app-id = "^dev\\.noctalia\\.Noctalia$"; } ];
          open-floating = true;
          default-column-width.fixed = 1080;
          default-window-height.fixed = 920;
        }
      ];

      layer-rules = [
        {

          matches = [ { namespace = "^noctalia-wallpaper"; } ];
          place-within-backdrop = true;
        }
      ];

      spawn-at-startup = [
        { command = [ "awww-daemon" ]; }
        { command = [ "waypaper" "--restore" ]; }
        { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }

        { command = [ "noctalia" ]; }
      ];

      binds = with config.lib.niri.actions; {

        "Mod+Return".action = spawn "ghostty";
        "Mod+Shift+Return".action = spawn "kitty";
        "Mod+B".action = spawn "zen";
        "Mod+E".action = spawn "thunar";
        "Mod+Shift+D".action = spawn "fuzzel";

        "Print".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -";
        "Shift+Print".action = spawn "sh" "-c" "grim ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png";

        "Mod+Space".action = spawn "noctalia" "msg" "panel-toggle" "launcher";
        "Mod+S".action = spawn "noctalia" "msg" "panel-toggle" "control-center";
        "Mod+Comma".action = spawn "noctalia" "msg" "settings-toggle";
        "Alt+Tab".action = spawn "noctalia" "msg" "window-switcher";

        "XF86AudioRaiseVolume".action = spawn "noctalia" "msg" "volume-up";
        "XF86AudioLowerVolume".action = spawn "noctalia" "msg" "volume-down";
        "XF86AudioMute".action = spawn "noctalia" "msg" "volume-mute";
        "XF86MonBrightnessUp".action = spawn "noctalia" "msg" "brightness-up";
        "XF86MonBrightnessDown".action = spawn "noctalia" "msg" "brightness-down";

        "Mod+Q".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Up".action = focus-window-up;
        "Mod+Down".action = focus-window-down;
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-window-up;
        "Mod+J".action = focus-window-down;

        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;

        "Mod+R".action = switch-preset-column-width;
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";

        "Mod+1".action = focus-workspace 1;
  "Mod+2".action = focus-workspace 2;
  "Mod+3".action = focus-workspace 3;
  "Mod+4".action = focus-workspace 4;
  "Mod+Shift+1".action.move-column-to-workspace = [ 1 ];
  "Mod+Shift+2".action.move-column-to-workspace = [ 2 ];
  "Mod+Shift+3".action.move-column-to-workspace = [ 3 ];
  "Mod+Shift+4".action.move-column-to-workspace = [ 4 ];

        "Mod+Shift+E".action = quit;
      };

    };
  };
}