{
  ...
}:{
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      experimental-features = ["nix-command" "flakes"];
      accept-flake-config = true;
      builders-use-substitutes = true;
      keep-outputs = true;
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
        "https://hyprland.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      warn-dirty = false;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];

  programs.nix-index-database.comma.enable = true;
  programs.command-not-found.enable = false;
}
