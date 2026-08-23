{
  description = "Oryn's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvix = {
      url = "github:niksingh710/nvix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixvim.inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      stylix,
      nix-index-database,
      nur,
      nix-flatpak,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "oryn";

      # Package
      pkgsConfig = {
        allowUnfree = true;
      };

      pkgsOverlays = [
        nur.overlays.default
      ];

      # Arguments passed to every module
      sharedSpecialArgsFor = hostname: {
        inherit
          self
          inputs
          username
          hostname
          system
          ;
      };

      # System builder
      mkSystem =
        hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = sharedSpecialArgsFor hostname;
          modules = [
            "${self}/modules/common/configuration.nix"
            "${self}/hosts/${hostname}"

            # Modules
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

    in
    {
      nixosConfigurations = {
        ph315 = mkSystem "ph315";

      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
