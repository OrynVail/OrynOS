{
  pkgs,
  lib,
  ...
}: {
  # We only place the bare essentials.
  # Ambxst will handle the theme, keys, and animations.

  xdg.configFile = {
    # Keep monitors because you need to force 144Hz
    "hypr/monitors.conf".source = ./monitors.conf;
  };

  # Cleaned up: No zprofile, no keybindings, no animations.
}
