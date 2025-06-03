{
  pkgs,
  lib,
  ...
}: {
  # List of Hyprland specific packages
  environment.systemPackages = with pkgs; [
    file-roller
    gnome-text-editor
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

  # Polkit core + “always-yes” rule
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function (action, subject) {
        if (subject.isInGroup("wheel")) {
          if (action.id.startsWith("org.freedesktop.udisks2.") ||
              action.id == "org.gtk.vfs.file-operations-helper")
            return polkit.Result.YES;
        }
      });
    '';
  };

  # PAM hook so the key-ring unlocks with TTY password
  security.pam.services.login.enableGnomeKeyring = true;
}
