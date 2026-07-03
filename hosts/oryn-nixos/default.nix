{
  pkgs,
  username,
  inputs,
  self,
  ...
}: {
  imports = [
    # core
    "${self}/modules/core/boot.nix"
    "${self}/modules/core/network.nix"
    "${self}/modules/core/power.nix"
    "${self}/modules/core/security.nix"
    "${self}/modules/core/users.nix"

    # desktop
    "${self}/modules/desktop/fonts.nix"
    "${self}/modules/desktop/gnome.nix"
    "${self}/modules/desktop/stylix.nix"

    # hardware
    "${self}/modules/hardware/hardware.nix"
    "${self}/modules/hardware/nvidia.nix"

    # nix
    "${self}/modules/nix/nh.nix"
    "${self}/modules/nix/settings.nix"

    # programs
    "${self}/programs/documents.nix"
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
}
