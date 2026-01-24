{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # --- ENVIRONMENT (Nvidia Optimized) ---
      env = [
        "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NIXOS_OZONE_WL,1"
      ];

      # --- STARTUP ---
      exec-once = [
        "ambxst"
        "blueman-applet"
        "nm-applet"
        "wl-paste --type text --watch cliphist store"
        "gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula'"
      ];

      # --- IMPORTS ---
      source = [
        "~/.config/hypr/monitors.conf"
      ];

      # --- DECORATION (CRITICAL FOR TRANSPARENCY) ---

      decoration = {
        rounding = 4;
        active_opacity = 0.9;
        inactive_opacity = 0.8;
        blur = {
          enabled = false;
        };
        shadow = {
          enabled = false;
        };
      };

      # --- INPUT CONFIG (CS:GO / Coding Optimized) ---
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

      # --- GENERAL SETTINGS ---

      # --- MISC SETTINGS ---
      misc = {
        vrr = 1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      # --- ANIMATIONS ---
      animations = {
        enabled = true;

        bezier = [
          "quart, 0.25, 1, 0.5, 1"
        ];

        animation = [
          "windows, 1, 6, quart, slide"
        # "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 6, quart"
          "borderangle, 1, 6, quart"
          "fade, 1, 6, quart"
          "workspaces, 1, 6, quart"
        ];
      };

      # --- WINDOW RULES ---
      windowrulev2 = [
        # Opacity: [Active] [Inactive] [Fullscreen]
        "opacity 0.90 0.90 1.0, class:^(firefox)$"
        "opacity 0.90 0.90 1.0, class:^(firefox-beta)$"
        "opacity 0.90 0.90 1.0, class:^(Brave-browser)$"
        "opacity 0.80 0.80 1.0, class:^(code-oss)$"
        "opacity 0.80 0.80 1.0, class:^(Code)$"
        "opacity 0.90 0.90 1.0, class:^(kitty)$"
        "opacity 0.90 0.90 1.0, class:^(Alacritty)$"
        "opacity 0.80 0.80 1.0, class:^(org.kde.dolphin)$"
        "opacity 0.80 0.80 1.0, class:^(org.gnome.Nautilus)$"
        "opacity 0.80 0.80 1.0, class:^(nwg-look)$"
        "opacity 0.80 0.80 1.0, class:^(qt5ct)$"
        "opacity 0.80 0.80 1.0, class:^(kvantummanager)$"

        # System Tools
        "opacity 0.80 0.70 1.0, class:^(org.pulseaudio.pavucontrol)$"
        "opacity 0.80 0.70 1.0, class:^(blueman-manager)$"
        "opacity 0.80 0.70 1.0, class:^(nm-applet)$"

        # Media & Social
        "opacity 0.70 0.70 1.0, class:^(Spotify)$"
        "opacity 0.80 0.80 1.0, class:^(discord)$"
        "opacity 0.80 0.80 1.0, class:^(vesktop)$"

        # Floating Rules
        "float, class:^(Signal)$"
        "float, class:^(com.github.rafostar.Clapper)$"
        "float, class:^(app.drey.Warp)$"
        "float, class:^(net.davidotek.pupgui2)$"
        "float, class:^(yad)$"
        "float, class:^(eog)$"
        "float, class:^(io.github.alainm23.planify)$"
        "float, class:^(io.missioncenter.MissionCenter)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(nm-applet)$"
        "float, class:^(org.pulseaudio.pavucontrol)$"

        # Picture-in-Picture
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "move 73% 72%, title:^(Picture-in-Picture)$"
        "size 25% 25%, title:^(Picture-in-Picture)$"
        "noinitialfocus, title:^(Picture-in-Picture)$"
      ];
    };
  };
}
