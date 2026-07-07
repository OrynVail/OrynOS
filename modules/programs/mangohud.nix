{ pkgs, ... }: {
  # Enable MangoHud via Home Manager module
  programs.mangohud = {
    enable = true;
  };
}
