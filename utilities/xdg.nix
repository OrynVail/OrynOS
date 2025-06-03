{
  config,
  pkgs,
  lib,
  ...
}: {
  # Ensure the necessary portal backends are available
  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

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
