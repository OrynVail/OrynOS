{
  pkgs,
  username,
  ...
}:{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 5";
    };
    flake = "/home/${username}/Projects/OrynOS";
  };
}
