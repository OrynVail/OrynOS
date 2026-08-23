{
  pkgs,
  inputs,
  self,
  ...
}: {
  imports = [
    "${self}/hosts/ph315/hardware-configuration.nix"
    "${self}/hosts/ph315/windows-drives.nix"

    # NixOS Hardware laptop
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # common
    "${self}/modules/common"

    # Host-specific
    "${self}/modules/mixins/nvidia-laptop.nix"
  ];

  boot.kernelParams = [ "video=DP-3:1920x1080@144" ];

  environment.systemPackages = with pkgs; [
    sbctl
    brightnessctl
    ddcutil
  ];
}
