{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    file-roller
    loupe
    gvfs
    polkit_gnome
    seahorse
  ];

  # Trash, mounting and network shares for the TUI file managers
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable security services
  programs.dconf.enable = true;

  # PAM hook
  security.pam.services.login.enableGnomeKeyring = true;
}
