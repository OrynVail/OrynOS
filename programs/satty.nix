{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:{
  home.packages = [pkgs.satty];

  programs.satty = {
    enable = true;
    settings = {
      general = {
          annotation-size-factor = 1.0;
          output-filename = "/home/oryn/Pictures/Screenshots/Screenshots-%Y-%m-%d_%H:%M:%S.png";
          save-after-copy = false;
          actions-on-enter = ["save-to-file"];
      };
    };
  };
}