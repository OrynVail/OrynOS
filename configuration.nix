{
  inputs,
  config,
  lib,
  username,
  hostname,
  theme,
  userPkgs,
  system,
  userConfig,
  ...
}: let
  # Package declaration
  pkgs = import inputs.hydenix.inputs.hydenix-nixpkgs {
    inherit (inputs.hydenix.lib) system;
    config.allowUnfree = true;
    overlays = [
      inputs.hydenix.lib.overlays
      inputs.nur.overlays.default
    ];
  };
in {
  # Any file that imports pkgs will use this
  nixpkgs.pkgs = pkgs;

  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    ./hosts/${hostname}/hardware-configuration.nix
    inputs.hydenix.lib.nixOsModules
    ./hosts/${hostname}/default.nix
    ./hosts/${hostname}/nvidia.nix

    # For Intel CPUs
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-intel

    # Other common modules
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs username hostname system theme userPkgs userConfig;
    };
    # backupFileExtension = "backup";

    users."${username}" = {
      imports = [
        inputs.hydenix.lib.homeModules
        # Nix-index-database - for comma and command-not-found
        inputs.nix-index-database.homeModules.nix-index
        ./home/${username}/${hostname}/default.nix
      ];
    };
  };

  # global configurations
  hydenix = {
    enable = true;

    hostname = hostname;
    timezone = "Asia/Kolkata";
    locale = "en_US.UTF-8";

    audio.enable = true;
    boot = {
      enable = true; # enable boot module
      useSystemdBoot = true; # disable for GRUB
      grubTheme = "Retroboot"; # or "Pochita"
      grubExtraConfig = ""; # additional GRUB configuration
      kernelPackages = pkgs.linuxPackages_zen; # default zen kernel
    };

    gaming.enable = true;
    hardware.enable = true;
    network.enable = true;
    nix.enable = true;
    sddm = {
      enable = false;
    };
    system.enable = true;
  };

  #! EDIT THESE VALUES (must match users defined above)
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "adbusers"
    ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}
