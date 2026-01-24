{
  description = "Oryn's NixOS Configuration";

  inputs = {
    # 1. Official Unstable Channel (Best for Hyprland/Gaming)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprsettings.url = "github:acropolis914/hyprsettings";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 2. Stylix (Theming Engine)
    stylix.url = "github:danth/stylix";

    # 3. Nix-Index (Command-not-found powers)
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rycee-nurpkgs = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Community Modules
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    hyprsettings,
    home-manager,
    stylix,
    nix-index-database,
    nur,
    nix-flatpak,
    spicetify-nix,
    nixos-hardware,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "oryn";
    hostname = "oryn-nixos";

    # Unified Package Config
    pkgsConfig = {
      allowUnfree = true;
    };
    
    pkgsOverlays = [
      nur.overlays.default
    ];

    # Arguments passed to every module
    sharedSpecialArgs = {
      inherit inputs username hostname system;
    };

  in {
    # 1. System Configuration
    nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
      specialArgs = sharedSpecialArgs;
      modules = [
        ./configuration.nix

        hyprsettings.nixosModules.default
        {
          programs.hyprsettings.enable = true;
        }
        
        # Modules injected directly here
        nix-flatpak.nixosModules.nix-flatpak
        stylix.nixosModules.stylix
        nix-index-database.nixosModules.nix-index

        # Global Nixpkgs Config
        {
          nixpkgs.config = pkgsConfig;
          nixpkgs.overlays = pkgsOverlays;
          i18n.inputMethod.enabled = nixpkgs.lib.mkForce null;
        }
      ];
    };

    # 2. Standalone Home Manager Configuration
    homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config = pkgsConfig;
        overlays = pkgsOverlays;
      };
      
      extraSpecialArgs = sharedSpecialArgs;
      modules = [
        stylix.homeManagerModules.stylix
        ./home/${username}/${hostname}/default.nix
      ];
    };
  };
}