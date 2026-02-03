{
  pkgs,
  username,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    ../../utilities/gnome.nix
    ../../programs/documents.nix
  ];

  # --- 1. Bootloader ---
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 8;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.enableContainers = true;

  # --- 2. Performance Core ---
  zramSwap.enable = true;

  # SSD Health
  services.fstrim.enable = true;

  # Network Optimization (BBR + FQ)
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };

  # --- 3. Networking ---
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    nameservers = ["8.8.8.8" "1.1.1.1"];
  };

  systemd.services = {
    NetworkManager-wait-online.enable = false;
    plymouth-quit-wait.enable = false;
  };
  services.resolved.enable = true;

  # --- 4. Services ---
  services.displayManager.defaultSession = "hyprland";
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.printing.enable = false;
  services.flatpak.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # --- 5. Packages & Tools ---
  environment.systemPackages = with pkgs; [
    # Core Tools
    nh
    sbctl
    wget
    curl
    git

    # Dev
    gcc
    nodejs
    python3
    cudaPackages.cudatoolkit

    # Utils
    wmctrl
    eza
    tree
    mc
    killall
  ];

  # --- 6. Bluetooth ---

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # crucial: ensures it doesn't default to 'off' on login
    settings = {
      General = {
        Experimental = true; # Enables battery % reporting for headsets/controllers
      };
    };
  };

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.blueman.enable = true;

  programs.zsh.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 5";
    };
    flake = "/home/${username}/Projects/OrynOS";
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };
}
