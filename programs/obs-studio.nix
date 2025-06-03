{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    obs-studio
  ];
}
