{
  pkgs,
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    # NixOS Hardware
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ../../modules/common

    ../../modules/mixins/nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
    sbctl
    brightnessctl
    ddcutil
  ];
}
