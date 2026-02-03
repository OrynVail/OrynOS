{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      env = [
        "AQ_DRM_DEVICES,/dev/dri/card0:dev/dri/card1"
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

      source = [
      ];

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
    };
  };
}
