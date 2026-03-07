{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    file-roller
    loupe
    nautilus
    gvfs
    polkit_gnome
    seahorse
  ];

  # Back-end services Nautilus expects
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable security services
  programs.dconf.enable = true;

  # PAM hook
  security.pam.services.login.enableGnomeKeyring = true;
}
