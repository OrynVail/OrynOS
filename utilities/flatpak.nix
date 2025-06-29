{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.nix-flatpak.homeManagerModules.nix-flatpak];

  # Enable flatpak service
  services.flatpak = {
    # List of packages to install
    packages = [
      #   {
      #  appId = "com.brave.Browser";
      #  origin = "flathub";
      #}
      # { appId = "com.obsproject.Studio"; origin = "flathub"; }
    ];

    # Remove flatpaks that were manually installed but not listed here
    uninstallUnmanaged = true;

    # Disable automatic updates
    update.auto.enable = false;
  };

  services.flatpak.remotes = [
    {
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }
  ];

  home.packages = [pkgs.flatpak];

  # Uncomment to add flatpak directories to XDG data dirs
  # This helps with desktop integration
  # xdg.systemDirs.data = [
  #   "/var/lib/flatpak/exports/share"
  #   "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  # ];
}
