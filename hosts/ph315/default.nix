{
  pkgs,
  inputs,
  self,
  ...
}: {
  imports = [
    "${self}/hosts/ph315/hardware-configuration.nix"

    # NixOS Hardware laptop optimizations
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # common
    "${self}/modules/common"

    # Host-specific
    "${self}/modules/mixins/nvidia-laptop.nix"
  ];

  environment.systemPackages = with pkgs; [
    sbctl
    brightnessctl
    ddcutil
  ];
}
