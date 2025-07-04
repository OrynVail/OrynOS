{
  config,
  lib,
  pkgs,
  userConfig, 
  theme,
  ...
}:
with lib.hm.gvariant; 

let
  palette = theme.colorScheme.palette;
  
  customPapirusBlack = pkgs.stdenv.mkDerivation {
  pname = "papirus-dark-black";
  version = "1.0";
  
  src = ../../../themes/Papirus-Black;  
  
  nativeBuildInputs = [ pkgs.gtk3 ];

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r . $out/share/icons/Papirus-Black
    
    gtk-update-icon-cache -f $out/share/icons/Papirus-Black
  '';

  passthru.iconThemeName = "Papirus-Black";
};  
  colloid-black = pkgs.colloid-gtk-theme.override {
    colorVariants = [ "dark" ];
    tweaks = [ "black" "rimless" ];  
};

in {
  imports = [ 
    ../../../programs/fastfetch.nix
  ];

  # Gnome extensions 
  home.packages = with pkgs; [
    colloid-black
    gnomeExtensions.auto-move-windows
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-history
    gnomeExtensions.dash-to-dock
    gnomeExtensions.just-perfection
    gnomeExtensions.pop-shell
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.space-bar
    gnomeExtensions.transparent-top-bar
    gnomeExtensions.unblank
    gnomeExtensions.user-themes
  ];
  
  home.pointerCursor = {
    name = "Bibata-Modern-Classic"; # or one of the valid names you confirm
    package = pkgs.bibata-cursors;
    size = 20;
  };
  
  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Dark";
      package = colloid-black; 
    };
    iconTheme = {
      name = "Papirus-Black"; 
      package = customPapirusBlack;
    };
    font = {
      name = theme.fonts.sansSerif.name; 
      size = 11;
    };

    # For GTK4 applications, particularly those not using libadwaita heavily.
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "icon-theme" = "Papirus-Black";
      "gtk-theme" = "Colloid-Dark";
      "color-scheme" = "prefer-dark";
      "cursor-theme" = "${theme.cursor.name}";
      "font-name" = "${theme.fonts.sansSerif.name} 11";
      "document-font-name" = "${theme.fonts.serif.name} 11";
      "monospace-font-name" = "${theme.fonts.monospace.name} 11";
      "enable-animations" = false;
      "enable-hot-corners" = false;
      "font-antialiasing" = "grayscale";
      "font-hinting" = "slight";
      "show-battery-percentage" = true;
      "toolkit-accessibility" = false;
    };

    "org/gtk/gtk4/settings/color-chooser" = {
      "custom-colors" = [(mkTuple [0.74901962280273438 0.7450980544090271 0.7764706015586853 1.0])];
      "selected-color" = mkTuple [true 0.87058824300765991 0.86666667461395264 0.85490196943283081 1.0];
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      "show-hidden" = true;
    };

    "org/gtk/settings/file-chooser" = {
      "date-format" = "regular";
      "location-mode" = "path-bar";
      "show-hidden" = true;
      "show-size-column" = true;
      "show-type-column" = true;
      "sort-column" = "name";
      "sort-directories-first" = true;
      "sort-order" = "ascending";
      "type-format" = "category";
      "view-type" = "list";
    };
    
    "org/gnome/desktop/background" = {
      "color-shading-type" = "solid";
      "picture-options" = "zoom";
      "picture-uri" = "file://${theme.wallpaper}";
      "picture-uri-dark"  = "file://${theme.wallpaper}";
      "primary-color" = "#000000000000";
      "secondary-color" = "#000000000000";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      "delay" = mkUint32 250;
      "repeat-interval" = mkUint32 20;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      "speed" = 0.0;
      "accel-profile" = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      "speed" = 0.0;
      "tap-to-click" = true;
      "two-finger-scrolling-enabled" = true;
    };

    "org/gnome/desktop/privacy" = {
      "old-files-age" = mkUint32 30;
      "recent-files-max-age" = -1;
    };

    "org/gnome/desktop/session" = {
      "idle-delay" = mkUint32 0;
    };

    "org/gnome/desktop/sound" = {
      "event-sounds" = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      "close" = ["<Super>q"];
      "minimize" = ["<Super>comma"];
      "move-to-center" = ["<Control><Alt>c"];
      "move-to-workspace-1" = ["<Super><Shift>1"];
      "move-to-workspace-10" = ["<Super><Shift>0"];
      "move-to-workspace-2" = ["<Super><Shift>2"];
      "move-to-workspace-3" = ["<Super><Shift>3"];
      "move-to-workspace-4" = ["<Super><Shift>4"];
      "move-to-workspace-5" = ["<Super><Shift>5"];
      "move-to-workspace-6" = ["<Super><Shift>6"];
      "move-to-workspace-7" = ["<Super><Shift>7"];
      "move-to-workspace-8" = ["<Super><Shift>8"];
      "move-to-workspace-9" = ["<Super><Shift>9"];
      "switch-applications" = ["<Super>Tab"];
      "switch-to-workspace-1" = ["<Super>1"];
      "switch-to-workspace-2" = ["<Super>2"];
      "switch-to-workspace-3" = ["<Super>3"];
      "switch-to-workspace-4" = ["<Super>4"];
      "switch-to-workspace-5" = ["<Super>5"];
      "switch-to-workspace-6" = ["<Super>6"];
      "switch-to-workspace-7" = ["<Super>7"];
      "switch-to-workspace-8" = ["<Super>8"];
      "switch-to-workspace-9" = ["<Super>9"];
      "toggle-fullscreen" = ["<Super>m"];
    };

    "org/gnome/desktop/wm/preferences" = {
      "button-layout" = lib.mkForce "";
      "focus-mode" = "sloppy";
      "num-workspaces" = 5;
      "titlebar-font" = "${theme.fonts.monospace.name} 10";
      "workspace-names" = [" "];
    };

    "org/gnome/mutter" = {
      "center-new-windows" = true;
      "dynamic-workspaces" = true;
      "edge-tiling" = false;
    };

    "org/gnome/nautilus/preferences" = {
      "default-folder-viewer" = "list-view";
      "migrated-gtk-settings" = true;
      "search-filter-time-type" = "last_modified";
      "search-view" = "list-view";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      "night-light-enabled" = true;
      "night-light-last-coordinates" = mkTuple [44.437359000257999 26.090661799999999];
      "night-light-temperature" = mkUint32 4000;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      "custom-keybindings" = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/"
      ];
      "screensaver" = ["<Alt><Ctrl>l"];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      "binding" = "<Control>space";
      "command" = "ulauncher-toggle";
      "name" = "Ulauncher";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      "binding" = "<Shift><Super>s";
      "command" = "flameshot gui";
      "name" = "Flameshot";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      "binding" = "<Shift><Alt>2";
      "command" = "ocr";
      "name" = "OCR";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      "binding" = "<Shift><Super>Return";
      "command" = "alacritty";
      "name" = "Alacritty";
    };
    
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      "binding" = "<Shift><Super>b";
      "command" = "firefox";
      "name" = "Firefox";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      "binding" = "<Shift><Super>f";
      "command" = "nautilus";
      "name" = "Files";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      "binding" = "<Alt><Ctrl>q";
      "command" = "gnome-session-quit";
      "name" = "Logout";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
      "binding" = "<Shift><Super>t";
      "command" = "gnome-terminal";
      "name" = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      "sleep-inactive-ac-type" = "nothing";
      "sleep-inactive-battery-type" = "nothing";
    };
    
    "org/gnome/TextEditor" = {
      "show-line-numbers" = true;
      "highlight-current-line" = true;
    };

    "org/gnome/shell" = {
      "disable-user-extensions" = false;
      "enabled-extensions" = [
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "clipboard-history@alexsaveau.dev"
        "dash-to-dock@micxgx.gmail.com"
        "just-perfection-desktop@just-perfection"
        "pop-shell@system76.com"
        "rounded-window-corners@fxgn"
        "space-bar@luchrioh"
        "transparent-top-bar@ftpix.com"
        "unblank@sun.wxg@gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      "favorite-apps" = [
        "thunderbird.desktop"
        "org.telegram.desktop.desktop"
        "Alacritty.desktop"
        "firefox-beta.desktop"
        "org.gnome.Nautilus.desktop"
        "obsidian.desktop"
        "org.gnome.TextEditor.desktop"
        "code.desktop"
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      "settings-version" = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      "pipeline" = "pipeline_default_rounded";
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      "pipeline" = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      "pipeline" = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      "pipeline" = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      "pipeline" = "pipeline_default";
    };

    "org/gnome/shell/extensions/clipboard-history" = {
      "display-mode" = 3;
      "next-entry" = ["<Shift><Alt>j"];
      "prev-entry" = ["<Shift><Alt>k"];
      "toggle-menu" = ["<Shift><Alt>v"];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      "animate-show-apps" = false;
      "apply-custom-theme" = false;
      "autohide" = true;
      "background-opacity" = 0.0;
      "custom-background-color" = false;
      "custom-theme-shrink" = true;
      "dash-max-icon-size" = 32;
      "dock-fixed" = false;
      "dock-position" = "BOTTOM";
      "extend-height" = false;
      "height-fraction" = 0.9;
      "hot-keys" = false;
      "intellihide" = true;
      "intellihide-mode" = "ALL_WINDOWS";
      "preferred-monitor" = -2;
      "preferred-monitor-by-connector" = "DisplayPort-0";
      "preview-size-scale" = 0.0;
      "show-show-apps-button" = false;
      "show-trash" = false;
      "transparency-mode" = "FIXED";
    };

    "org/gnome/shell/extensions/pop-shell" = {
      "active-hint" = false;
      "gap-inner" = mkUint32 1;
      "gap-outer" = mkUint32 1;
      "tile-by-default" = true;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      "accessibility-menu" = true;
      "activities-button" = false;
      "activities-button-icon-monochrome" = false;
      "activities-button-label" = true;
      "animation" = 0;
      "app-menu" = false;
      "app-menu-icon" = true;
      "app-menu-label" = true;
      "background-menu" = true;
      "clock-menu" = true;
      "controls-manager-spacing-size" = 0;
      "dash" = true;
      "dash-icon-size" = 0;
      "dash-separator" = true;
      "double-super-to-appgrid" = true;
      "gesture" = true;
      "hot-corner" = false;
      "keyboard-layout" = true;
      "notification-banner-position" = 2;
      "osd" = false;
      "panel" = true;
      "panel-arrow" = true;
      "panel-button-padding-size" = 4;
      "panel-corner-size" = 0;
      "panel-in-overview" = true;
      "panel-indicator-padding-size" = 0;
      "panel-notification-icon" = true;
      "panel-size" = 0;
      "power-icon" = true;
      "quick-settings" = true;
      "ripple-box" = true;
      "screen-sharing-indicator" = true;
      "search" = true;
      "show-apps-button" = true;
      "startup-status" = 0;
      "theme" = false;
      "window-demands-attention-focus" = false;
      "window-menu-take-screenshot-button" = true;
      "window-picker-icon" = true;
      "window-preview-caption" = true;
      "window-preview-close-button" = true;
      "workspace" = false;
      "workspace-background-corner-size" = 0;
      "workspace-peek" = true;
      "workspace-popup" = true;
      "workspace-switcher-size" = 0;
      "workspace-wrap-around" = false;
      "workspaces-in-app-grid" = true;
    };

    "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
      skip-libadwaita-app = false;
      border-width = 0;
      border-color = mkTuple [
        0.71764707565307617
        0.74117660522460938
        0.97254902124404907
        1.0
      ];
      global-rounded-corner-settings = [
        (mkDictionaryEntry [
          "padding"
          (mkVariant [
            (mkDictionaryEntry ["left" (mkUint32 1)])
            (mkDictionaryEntry ["right" (mkUint32 1)])
            (mkDictionaryEntry ["top" (mkUint32 1)])
            (mkDictionaryEntry ["bottom" (mkUint32 1)])
          ])
        ])
        (mkDictionaryEntry [
          "keepRoundedCorners"
          (mkVariant [
            (mkDictionaryEntry ["maximized" false])
            (mkDictionaryEntry ["fullscreen" false])
          ])
        ])
        (mkDictionaryEntry ["borderRadius" (mkVariant (mkUint32 8))])
        (mkDictionaryEntry ["smoothing" (mkVariant 0.0)])
        (mkDictionaryEntry [
          "borderColor"
          (mkVariant (mkTuple [
            0.71764707565307617
            0.74117660522460938
            0.97254902124404907
            1.0
          ]))
        ])
        (mkDictionaryEntry ["enabled" (mkVariant true)])
      ];
      settings-version = mkUint32 7;
    };

    "org/gnome/shell/extensions/space-bar/appearance" = {
      "inactive-workspace-text-color" = "rgb(154,153,150)";
      "workspace-margin" = 3;
      "workspaces-bar-padding" = 3;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      "scroll-wheel" = "panel";
      "show-empty-workspaces" = false;
      "smart-workspace-names" = false;
      "toggle-overview" = false;
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      "enable-activate-workspace-shortcuts" = true;
      "enable-move-to-workspace-shortcuts" = true;
    };

    "org/gnome/shell/extensions/unblank" = {
      "power" = false;
      "time" = 0;
    };

    "org/gnome/shell/keybindings" = {
      "show-screen-recording-ui" = ["<Shift><Super>r"];
      "show-screenshot-ui" = ["<Ctrl><Alt>S"];
      "switch-to-application-1" = [];
      "switch-to-application-2" = [];
      "switch-to-application-3" = [];
      "switch-to-application-4" = [];
      "switch-to-application-5" = [];
      "switch-to-application-6" = [];
      "switch-to-application-7" = [];
      "switch-to-application-8" = [];
      "switch-to-application-9" = [];
      "toggle-application-view" = ["<Super>a"];
      "toggle-message-tray" = ["<Super>v"];
    };

    "org/gnome/system/location" = {
      "enabled" = true;
    };

    "system/locale" = {
      "region" = "en_US.UTF-8";
    };
  };

  # pop-shell settings
  xdg.configFile = {
    "pop-shell/config.json".text = ''
      {
        "float": [
          {
            "class": "ulauncher"
          },
          {
            "class": "org.gnome.Calculator"
          },
          {
            "class": "zoom",
            "disabled": true
          },
          {
            "class": "crx_.*"
          },
          {
            "title": "crx_.*"
          },
          {
            "title": "^(.*is sharing (your screen|a window)\\.)$"
          }
        ],
        "skiptaskbarhidden": [],
        "log_on_focus": false
      }
    '';
  };
}
