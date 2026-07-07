{
  pkgs,
  inputs,
  hostname,
  system,
  ...
}:{


  hardware = {
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;
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
