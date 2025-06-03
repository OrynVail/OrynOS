{
  pkgs,
  lib,
  ...
}: {
  home.file.".config/hypr/monitors.conf" = {
    source = lib.mkForce ./monitors.conf;
  };

  home.file.".config/hypr/animations.conf" = {
    source = lib.mkForce ./animations.conf;
  };

  home.file.".config/hypr/userprefs.conf" = {
    source = lib.mkForce ./userprefs.conf;
  };

  home.file.".config/hypr/keybindings.conf" = {
    source = lib.mkForce ./keybindings.conf;
  };

  home.file.".config/hypr/hypridle.conf" = {
    source = lib.mkForce ./hypridle.conf;
  };

  home.file.".config/hypr/hyde.conf" = {
    source = lib.mkForce ./hyde.conf;
  };

  home.file.".config/hypr/hyprland.conf" = {
    source = lib.mkForce ./hyprland.conf;
  };
}
