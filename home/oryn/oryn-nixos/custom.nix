{
  pkgs,
  lib,
  ...
}: {
  xdg.configFile = {
    # Keep monitors because you need to force 144Hz
    "hypr/monitors.conf".source = ./monitors.conf;
  };
}
