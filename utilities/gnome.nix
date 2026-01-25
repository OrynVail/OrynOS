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
  services.gnome.gnome-keyring.enable = true;

  # Enable security services
  programs.dconf.enable = true;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };

    # Prevent replacing the running kernel without a reboot
    protectKernelImage = true;
    acme.acceptTerms = true;
  };

  # PAM hook so the key-ring unlocks with TTY password
  security.pam.services.login.enableGnomeKeyring = true;
}
