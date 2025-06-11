{
  config,
  userConfig,
  pkgs,
  lib,
  inputs,
  theme,
  userPkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    ../../utilities/gnome.nix
    ../../programs/documents.nix
  ];

  # Fonts
  fonts.packages = theme.fontPackages;

  # Bootloader.
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];

  # lanzaboote
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    nameservers = ["8.8.8.8" "1.1.1.1"];
  };

  # Disable systemd services that are affecting the boot time
  systemd.services = {
    NetworkManager-wait-online.enable = false;
    plymouth-quit-wait.enable = false;
  };

  services.resolved.enable = true;

  # Kernel tweaks
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };

  boot.kernelParams = [
    "video=DP-3:e" # Enable DisplayPort-3
    "video=eDP-1:d"
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = lib.mkForce false;
  services.getty.autologinUser = username;
  console.enable = true;
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = false;

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    gcc
    sbctl
    wget
    efibootmgr
    nodejs
    curl
    python3
    cudaPackages.cudatoolkit
    wmctrl
    eza
    tree
  ];

  # System-wide zsh enablement
  programs.zsh.enable = true;

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
}
