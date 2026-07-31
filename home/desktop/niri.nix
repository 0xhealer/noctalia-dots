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
          drag-to-drag = true;
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
      };

      # Autostart Programs
      spawn-at-startup = [
        { command = [ "swww-daemon" ]; }
        { command = [ "waypaper" "--restore" ]; }
        { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }
      ];

      # Keybindings
      binds = with config.lib.niri.actions; {
        # Applications & Utilities
        "Mod+Return".action = spawn "ghostty";
        "Mod+Shift+Return".action = spawn "kitty";
        "Mod+B".action = spawn "zen";
        "Mod+E".action = spawn "thunar";
        "Mod+D".action = spawn "fuzzel"; # Or your preferred launcher

        # Screenshots (grim + slurp + swappy)
        "Print".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -";
        "Shift+Print".action = spawn "sh" "-c" "grim ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png";

        # Audio & Media Controls
        "XF86AudioRaiseVolume".action = spawn "pamixer" "-i" "5";
        "XF86AudioLowerVolume".action = spawn "pamixer" "-d" "5";
        "XF86AudioMute".action = spawn "pamixer" "-t";
        "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "+10%";
        "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "10%-" ;

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
        "Mod+Shift+1".action = move-column-to-workspace 1;
        "Mod+Shift+2".action = move-column-to-workspace 2;
        "Mod+Shift+3".action = move-column-to-workspace 3;
        "Mod+Shift+4".action = move-column-to-workspace 4;

        # System Controls
        "Mod+Shift+E".action = quit;
      };
    };
  };
}