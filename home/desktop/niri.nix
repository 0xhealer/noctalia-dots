{ pkgs, config, inputs, lib, ... }:

let
  inherit (inputs.niri.lib.kdl) node plain leaf flag;
in
{
  programs.niri.config = [
    (plain "input" [
      (plain "keyboard" [
        (plain "xkb" [
          (leaf "layout" "us")
        ])
      ])
      (plain "touchpad" [
        (flag "tap")
        (flag "drag")
        (flag "natural-scroll")
      ])
      (plain "mouse" [])
    ])

    (plain "layout" [
      (leaf "gaps" 12)
      (leaf "center-focused-column" "never")
      (leaf "background-color" "transparent")

      (plain "default-column-width" [
        (leaf "proportion" 0.5)
      ])

      (plain "focus-ring" [
        (leaf "width" 2)
        (leaf "active-color" "#7aa2f7")
        (leaf "inactive-color" "#414868")
      ])

      (plain "border" [
        (flag "off")
      ])
    ])

    (plain "overview" [
      (plain "workspace-shadow" [
        (flag "off")
      ])
    ])

    (plain "window-rule" [
      (leaf "geometry-corner-radius" { top-left = 20.0; top-right = 20.0; bottom-left = 20.0; bottom-right = 20.0; })
      (flag "clip-to-geometry")
    ])

    (plain "window-rule" [
      (leaf "match" { app-id = "^dev\\.noctalia\\.Noctalia$"; })
      (flag "open-floating")
      (plain "default-column-width" [ (leaf "fixed" 1080) ])
      (plain "default-window-height" [ (leaf "fixed" 920) ])
    ])

    (plain "window-rule" [
      (plain "background-effect" [
        (leaf "blur" true)
        (leaf "xray" false)
      ])
    ])

    (plain "layer-rule" [
      (leaf "match" { namespace = "^noctalia-wallpaper"; })
      (flag "place-within-backdrop")
    ])

    (plain "layer-rule" [
      (leaf "match" { namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"; })
      (plain "background-effect" [
        (leaf "xray" false)
      ])
    ])

    (plain "layer-rule" [
      (leaf "match" { namespace = "noctalia-window-switcher"; })
      (plain "background-effect" [
        (leaf "blur" true)
        (leaf "xray" false)
      ])
    ])

    (plain "blur" [
      (leaf "passes" 2)
      (leaf "offset" 3.0)
      (leaf "noise" 0.03)
      (leaf "saturation" 1.0)
    ])

    (leaf "spawn-at-startup" [ "awww-daemon" ])
    (leaf "spawn-at-startup" [ "waypaper" "--restore" ])
    (leaf "spawn-at-startup" [ "wl-paste" "--watch" "cliphist" "store" ])
    (leaf "spawn-at-startup" [ "noctalia" ])

    (plain "binds" [
      (plain "Mod+Return" [ (leaf "spawn" [ "ghostty" ]) ])
      (plain "Mod+Shift+Return" [ (leaf "spawn" [ "kitty" ]) ])
      (plain "Mod+B" [ (leaf "spawn" [ "zen" ]) ])
      (plain "Mod+E" [ (leaf "spawn" [ "thunar" ]) ])
      (plain "Mod+Shift+D" [ (leaf "spawn" [ "fuzzel" ]) ])

      (plain "Print" [ (leaf "spawn" [ "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -" ]) ])
      (plain "Shift+Print" [ (leaf "spawn" [ "sh" "-c" "grim ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png" ]) ])

      (plain "Mod+Space" [ (leaf "spawn" [ "noctalia" "msg" "panel-toggle" "launcher" ]) ])
      (plain "Mod+S" [ (leaf "spawn" [ "noctalia" "msg" "panel-toggle" "control-center" ]) ])
      (plain "Mod+Comma" [ (leaf "spawn" [ "noctalia" "msg" "settings-toggle" ]) ])
      (plain "Alt+Tab" [ (leaf "spawn" [ "noctalia" "msg" "window-switcher" ]) ])

      (plain "XF86AudioRaiseVolume" [ (leaf "spawn" [ "noctalia" "msg" "volume-up" ]) ])
      (plain "XF86AudioLowerVolume" [ (leaf "spawn" [ "noctalia" "msg" "volume-down" ]) ])
      (plain "XF86AudioMute" [ (leaf "spawn" [ "noctalia" "msg" "volume-mute" ]) ])
      (plain "XF86MonBrightnessUp" [ (leaf "spawn" [ "noctalia" "msg" "brightness-up" ]) ])
      (plain "XF86MonBrightnessDown" [ (leaf "spawn" [ "noctalia" "msg" "brightness-down" ]) ])

      (plain "Mod+Q" [ (flag "close-window") ])
      (plain "Mod+F" [ (flag "maximize-column") ])
      (plain "Mod+Shift+F" [ (flag "fullscreen-window") ])
      (plain "Mod+C" [ (flag "center-column") ])

      (plain "Mod+Left" [ (flag "focus-column-left") ])
      (plain "Mod+Right" [ (flag "focus-column-right") ])
      (plain "Mod+Up" [ (flag "focus-window-up") ])
      (plain "Mod+Down" [ (flag "focus-window-down") ])
      (plain "Mod+H" [ (flag "focus-column-left") ])
      (plain "Mod+L" [ (flag "focus-column-right") ])
      (plain "Mod+K" [ (flag "focus-window-up") ])
      (plain "Mod+J" [ (flag "focus-window-down") ])

      (plain "Mod+Shift+Left" [ (flag "move-column-left") ])
      (plain "Mod+Shift+Right" [ (flag "move-column-right") ])
      (plain "Mod+Shift+H" [ (flag "move-column-left") ])
      (plain "Mod+Shift+L" [ (flag "move-column-right") ])

      (plain "Mod+R" [ (flag "switch-preset-column-width") ])
      (plain "Mod+Minus" [ (leaf "set-column-width" "-10%") ])
      (plain "Mod+Equal" [ (leaf "set-column-width" "+10%") ])

      (plain "Mod+1" [ (leaf "focus-workspace" 1) ])
      (plain "Mod+2" [ (leaf "focus-workspace" 2) ])
      (plain "Mod+3" [ (leaf "focus-workspace" 3) ])
      (plain "Mod+4" [ (leaf "focus-workspace" 4) ])
      (plain "Mod+Shift+1" [ (leaf "move-column-to-workspace" 1) ])
      (plain "Mod+Shift+2" [ (leaf "move-column-to-workspace" 2) ])
      (plain "Mod+Shift+3" [ (leaf "move-column-to-workspace" 3) ])
      (plain "Mod+Shift+4" [ (leaf "move-column-to-workspace" 4) ])

      (plain "Mod+Shift+E" [ (flag "quit") ])
    ])
  ];
}
