{
  inputs,
  username,
  hostname,
  system,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit self inputs username hostname system;
    };
    users."${username}" = {
      imports = [
        "${self}/home/${username}/${hostname}/default.nix"
      ];
    };
  };
}
