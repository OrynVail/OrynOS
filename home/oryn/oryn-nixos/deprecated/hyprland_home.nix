{
  config,
  lib,
  userconfig,
  pkgs,
  inputs,
  theme,
  hydenixLib,
  ...
}:{  
  imports = [
    hydenixLib.homeModules.waybar
    hydenixLib.homeModules.theme
    ../../../utilities/hypridle.nix
    ../../../utilities/hyprlock.nix
    ../../../programs/wofi.nix
    ../../../programs/swappy.nix
    ../../../utilities/cliphist.nix
    ../../../utilities/waybar.nix
    ../../../utilities/kanshi.nix
    ../../../utilities/xdg.nix
    ../../../utilities/swaync
  ];
  
  # Waybar
  waybar.enable = true;

  # Consistent cursor theme 
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };

  # Source hyprland config from the home-manager store
  xdg.configFile = {
    "hypr/hyprland.conf" = {
      source = ./hyprland.conf;
    };

    "hypr/hyprpaper.conf".text = ''
      splash = false
      preload = ${theme.wallpaper}
      wallpaper = DP-3, ${theme.wallpaper}
      wallpaper = , ${theme.wallpaper}
    '';
    };

  dconf.settings = {
    "org/blueman/general" = {
      "plugin-list" = lib.mkForce ["!StatusNotifierItem"];
    };

    "org/blueman/plugins/powermanager" = {
      "auto-power-on" = true;
    };

    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
      "cursor-theme" = "${theme.cursor.name}";
      "font-name" = "${theme.fonts.sansSerif.name} 11";
      "document-font-name" = "${theme.fonts.serif.name} 11";
      "monospace-font-name" = "${theme.fonts.monospace.name} 11";
      "icon-theme" = "Tela-circle-dark";
    };

    "org/gnome/desktop/wm/preferences" = {
      "button-layout" = lib.mkForce "";
    };

    "org/gnome/nautilus/preferences" = {
      "default-folder-viewer" = "list-view";
      "migrated-gtk-settings" = true;
      "search-filter-time-type" = "last_modified";
      "search-view" = "list-view";
    };

    "org/gnome/nm-applet" = {
      "disable-connected-notifications" = true;
      "disable-vpn-notifications" = true;
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
      "sort-directories-first" = false;
      "sort-order" = "ascending";
      "type-format" = "category";
      "view-type" = "list";
     };
   };
 }
