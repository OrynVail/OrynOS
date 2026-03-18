{
  pkgs,
  lib,
  config,
  ...
}: {

  home.packages = with pkgs; [
    grimblast
    hyprpicker
  ];
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      env = [
        "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
        "XDG_SESSION_TYPE,wayland"
        "NIXOS_OZONE_WL,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11,*"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "OZONE_PLATFORM,wayland"
        "EGL_PLATFORM,wayland"
        "CLUTTER_BACKEND,wayland"
        "SDL_VIDEODRIVER,wayland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_ENABLE_HIGHDPI_SCALING,1"
        "NIXPKGS_ALLOW_UNFREE,1"
        "WLR_RENDERER,vulkan"
      ];

      exec-once = [
        "ambxst"
        "blueman-applet"
        "nm-applet"
      ];

      general = {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgba(c79595ff) rgba(c795aeff) 45deg";
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 16;
        active_opacity = 0.9;
        inactive_opacity = 0.8;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
        };
        shadow = {
          enabled = false;
        };
      };

      monitor = [
        ",preferred,auto,1"
        "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844, 1920x1080@144.00, 0x0, 1"
      ];

      # --- INPUT CONFIG ---
      input = {
        kb_layout = "us";
        kb_options = "grp:win_space_toggle";

        repeat_delay = 250;
        repeat_rate = 40;

        sensitivity = 0;
        accel_profile = "flat";
        follow_mouse = 1;
        mouse_refocus = false;

        touchpad = {
          natural_scroll = true;
        };
      };

      # --- MISC SETTINGS ---
      misc = {
        vfr = true;
        vrr = 1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        enable_swallow = true;
      };

      animations = {
        enabled = true;

        bezier = [
          "quart, 0.25, 1, 0.5, 1"
        ];

        animation = [
          "windows, 1, 6, quart"
          "windowsOut, 1, 6, quart, slide"
          "border, 1, 6, quart"
          "borderangle, 1, 6, quart"
          "fade, 1, 6, quart"
          "workspaces, 1, 6, quart"
        ];
      };

      # --- WINDOW RULES ---
      windowrule = [
        # Opacity: [Active] [Inactive] [Fullscreen]
        "match:class ^(firefox)$, opacity 0.90 0.90 1.0"
        "match:class ^(firefox-beta)$, opacity 0.90 0.90 1.0"
        "match:class ^(Brave-browser)$, opacity 0.90 0.90 1.0"
        "match:class ^(code-oss)$, opacity 0.80 0.80 1.0"
        "match:class ^(Code)$, opacity 0.80 0.80 1.0"
        "match:class ^(kitty)$, opacity 0.90 0.90 1.0"
        "match:class ^(Alacritty)$, opacity 0.90 0.90 1.0"
        "match:class ^(org.kde.dolphin)$, opacity 0.80 0.80 1.0"
        "match:class ^(org.gnome.Nautilus)$, opacity 0.80 0.80 1.0"
        "match:class ^(nwg-look)$, opacity 0.80 0.80 1.0"
        "match:class ^(qt5ct)$, opacity 0.80 0.80 1.0"
        "match:class ^(kvantummanager)$, opacity 0.80 0.80 1.0"

        # System Tools
        "match:class ^(org.pulseaudio.pavucontrol)$, opacity 0.80 0.70 1.0"
        "match:class ^(blueman-manager)$, opacity 0.80 0.70 1.0"
        "match:class ^(nm-applet)$, opacity 0.80 0.70 1.0"

        # Media & Social
        "match:class ^(Spotify)$, opacity 0.70 0.70 1.0"
        "match:class ^(discord)$, opacity 0.80 0.80 1.0"
        "match:class ^(vesktop)$, opacity 0.80 0.80 1.0"

        # Floating Rules
        "match:class ^(Signal)$, float on"
        "match:class ^(com.github.rafostar.Clapper)$, float on"
        "match:class ^(app.drey.Warp)$, float on"
        "match:class ^(net.davidotek.pupgui2)$, float on"
        "match:class ^(yad)$, float on"
        "match:class ^(eog)$, float on"
        "match:class ^(io.github.alainm23.planify)$, float on"
        "match:class ^(io.missioncenter.MissionCenter)$, float on"
        "match:class ^(blueman-manager)$, float on"
        "match:class ^(nm-applet)$, float on"
        "match:class ^(org.pulseaudio.pavucontrol)$, float on"

        # Picture-in-Picture
        "match:title ^(Picture-in-Picture)$, float on"
        "match:title ^(Picture-in-Picture)$, pin on"
        "match:title ^(Picture-in-Picture)$, move 73% 72%"
        "match:title ^(Picture-in-Picture)$, size 25% 25%"
        "match:title ^(Picture-in-Picture)$, no_initial_focus on"
      ];

      bind = [
        #"SUPER_SHIFT, S, exec, grimblast save area - | satty --filename -"
        #"SUPER_CONTROL, S, exec, grimblast save screen - | satty --filename -"

        # --- Apps ---
        "SUPER, T, exec, kitty"
        "SUPER, E, exec, nautilus"
        "SUPER, C, exec, code"
        "SUPER, B, exec, brave"

        # --- Window Management ---
        "SUPER, Q, killactive"
        "SUPER, Delete, exit"
        "SUPER, W, togglefloating"
        "SUPER, G, togglegroup"
        "SHIFT, F11, fullscreen"
        "SUPER_SHIFT, F, pin"
        "SUPER, J, togglesplit"

        # --- Group Navigation ---
        "SUPER_CONTROL, H, changegroupactive, b"
        "SUPER_CONTROL, L, changegroupactive, f"

        # --- Change Focus ---
        "SUPER, Left, movefocus, l"
        "SUPER, Right, movefocus, r"
        "SUPER, Up, movefocus, u"
        "SUPER, Down, movefocus, d"

        # --- Move Active Window ---
        "SUPER_SHIFT_CONTROL, left, movewindow, l"
        "SUPER_SHIFT_CONTROL, right, movewindow, r"
        "SUPER_SHIFT_CONTROL, up, movewindow, u"
        "SUPER_SHIFT_CONTROL, down, movewindow, d"

        # --- Workspaces: Navigation ---
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        "SUPER_CONTROL, Right, workspace, r+1"
        "SUPER_CONTROL, Left, workspace, r-1"
        "SUPER_CONTROL, Down, workspace, empty"
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"

        # --- Workspaces: Move Window ---
        "SUPER_SHIFT, 1, movetoworkspace, 1"
        "SUPER_SHIFT, 2, movetoworkspace, 2"
        "SUPER_SHIFT, 3, movetoworkspace, 3"
        "SUPER_SHIFT, 4, movetoworkspace, 4"
        "SUPER_SHIFT, 5, movetoworkspace, 5"
        "SUPER_SHIFT, 6, movetoworkspace, 6"
        "SUPER_SHIFT, 7, movetoworkspace, 7"
        "SUPER_SHIFT, 8, movetoworkspace, 8"
        "SUPER_SHIFT, 9, movetoworkspace, 9"
        "SUPER_SHIFT, 0, movetoworkspace, 10"

        "SUPER_CONTROL_ALT, Right, movetoworkspace, r+1"
        "SUPER_CONTROL_ALT, Left, movetoworkspace, r-1"

        # --- Workspaces: Move Window Silently ---
        "SUPER_ALT, 1, movetoworkspacesilent, 1"
        "SUPER_ALT, 2, movetoworkspacesilent, 2"
        "SUPER_ALT, 3, movetoworkspacesilent, 3"
        "SUPER_ALT, 4, movetoworkspacesilent, 4"
        "SUPER_ALT, 5, movetoworkspacesilent, 5"
        "SUPER_ALT, 6, movetoworkspacesilent, 6"
        "SUPER_ALT, 7, movetoworkspacesilent, 7"
        "SUPER_ALT, 8, movetoworkspacesilent, 8"
        "SUPER_ALT, 9, movetoworkspacesilent, 9"
        "SUPER_ALT, 0, movetoworkspacesilent, 10"
      ];

      # --- Holding Keys (Repeating) ---
      binde = [
        "SUPER_SHIFT, Right, resizeactive, 30 0"
        "SUPER_SHIFT, Left, resizeactive, -30 0"
        "SUPER_SHIFT, Up, resizeactive, 0 -30"
        "SUPER_SHIFT, Down, resizeactive, 0 30"
      ];

      # --- Mouse Binds ---
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bindr = [
        "SUPER, SUPER_L, exec, vicinae open"
      ];

      workspace = [
              # Binds workspaces to monitors (find desc with: hyprctl monitors)
              "1, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "2, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "3, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "4, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "5, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "6, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "7, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "8, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "9, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
              "10, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
      ];
    };
  };
}
