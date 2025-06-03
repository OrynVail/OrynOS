{
  config,
  pkgs,
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
}
