{
  config,
  pkgs,
  ...
}: {
  boot = {
    bootspec.enable = true;

    initrd = {
      systemd.enable = true;
    };
    
    supportedFilesystems = ["ntfs" "exfat" "vfat"];
    
    enableContainers = true;

    kernelPackages = pkgs.linuxPackages_latest;

    consoleLogLevel = 3;
    kernelParams = [
      "preempt=full"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "plymouth.use-simpledrm"
    ];

    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
    };

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 8;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };

    plymouth.enable = true;

    tmp = {
      useTmpfs = true;
    };
  };

  zramSwap.enable = true;

  services.fstrim.enable = true;

  systemd.services = {
    nix-daemon = {
      environment = {
        TMPDIR = "/var/tmp";
      };
    };
    NetworkManager-wait-online.enable = false;
    plymouth-quit-wait.enable = false;
  };
}