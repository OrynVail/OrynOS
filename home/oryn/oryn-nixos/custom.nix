{
  pkgs,
  config,
  lib,
  ...
}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland # Wayland portal
      xdg-desktop-portal-gtk # GTK portal
    ];

    config.common = {
      default = ["hyprland" "gtk"];
    };
  };

  dconf.enable = true;

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
    };
  };
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "kitty nvim %F";
    terminal = false;
    icon = "nvim";
    categories = [ "Utility" "TextEditor" "Development" ];
    mimeType = [ "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
  };
}
