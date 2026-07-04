{
  inputs,
  pkgs,
  username,
  hostname,
  system,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    "${self}/hosts/${hostname}/default.nix"
    "${self}/hosts/${hostname}/hardware-configuration.nix"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup"; # <--- Prevents install errors
    extraSpecialArgs = {
      inherit self inputs username hostname system;
    };
    users."${username}" = {
      imports = [
        "${self}/home/${username}/${hostname}/default.nix"
      ];
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];

  programs.nix-index-database.comma.enable = true;
  # Keeps the index updated automatically
  programs.command-not-found.enable = false; # Disable default to use nix-index

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # System Basics
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
