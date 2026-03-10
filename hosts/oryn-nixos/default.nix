{
  pkgs,
  username,
  inputs,
  ...
}: {
  imports = [
    ../../modules/boot.nix
    ../../modules/security.nix
    ../../modules/power.nix
    ../../modules/gnome.nix
    ../../modules/nh.nix
    ../../modules/stylix.nix
    ../../modules/fonts.nix
    ../../modules/nvidia.nix
    ../../modules/hardware.nix
    ../../modules/network.nix

    ../../programs/documents.nix
  ];

  # --- Services ---
  services.displayManager.defaultSession = "hyprland";
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.printing.enable = false;

  # --- Packages & Tools ---
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
    brightnessctl
    ddcutil
    gpu-screen-recorder
    grim
    slurp
  ];

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

  programs.zsh.enable = true;

  programs.gpu-screen-recorder.enable = true;

  nix.settings = {
    trusted-users = [ "root" "@wheel" ];
    experimental-features = ["nix-command" "flakes"];
    substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
        "https://hyprland.cachix.org/"
        "https://vicinae.cachix.org"
      ];
    trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      ];
    warn-dirty = false;
  };
}
