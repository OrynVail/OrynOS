{
  description = "Oryn's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hydenix = {
      url = "github:richen604/hydenix";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rycee-nurpkgs = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hydenix,
    lanzaboote,
    nur,
    nix-index-database,
    spicetify-nix,
    nixos-hardware,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "oryn";
    hostname = "oryn-nixos";

    userLevelPkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [nur.overlays.default];
    };

    orynTheme = import ./hosts/oryn-nixos/helios.nix {
      pkgs = userLevelPkgs;
      inherit inputs;
      lib = userLevelPkgs.lib;
    };

    userConfig = {name = username;};

    sharedSpecialArgs = {
      inherit inputs;
      inherit username hostname system;
      theme = orynTheme;
      userPkgs = userLevelPkgs;
      inherit userConfig;
    };

    orynNixOS = hydenix.inputs.hydenix-nixpkgs.lib.nixosSystem {
      inherit (hydenix.lib) system;
      specialArgs = sharedSpecialArgs;
      modules = [
        ./configuration.nix
        lanzaboote.nixosModules.lanzaboote

        ({lib, ...}: {
          i18n.inputMethod.enabled = lib.mkForce null;
        })
      ];
    };
  in {
    nixosConfigurations."${hostname}" = orynNixOS;

    # Standalone home-manager configuration
    # Allows: home-manager switch --flake .#oryn@oryn-nixos
    homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
      pkgs = userLevelPkgs;
      extraSpecialArgs = sharedSpecialArgs;
      modules = [
        ./home/${username}/${hostname}/default.nix
      ];
    };
  };
}
