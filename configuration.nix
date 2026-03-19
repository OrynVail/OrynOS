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

  programs.nix-index-database.comma.enable = true;
  # Keeps the index updated automatically
  programs.command-not-found.enable = false; # Disable default to use nix-index

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember";
        user = "greeter";
      };
    };
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

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "adbusers" "i2c"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}
