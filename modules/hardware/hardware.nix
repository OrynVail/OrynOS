{
  pkgs,
  inputs,
  hostname,
  system,
  ...
}:{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  hardware = {
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    i2c.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Name = "${hostname}";
          ControllerMode = "dual";
          FastConnectable = true;
          Experimental = true;
          KernelExperimental = true;
          JustWorksRepairing = "always";
          SecureConnections = "on";
        };
        GATT = {
          Cache = "always";
          Channels = 3;
        };
        Policy = {
          AutoEnable = true;
          ReconnectAttempts = 7;
          ReconnectIntervals = "1,2,4,8,16,32,64";
          ResumeDelay = 1;
        };
      };
    };
  };

  services.blueman.enable = true;
}
