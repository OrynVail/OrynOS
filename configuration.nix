{
  inputs,
  pkgs,
  username,
  hostname,
  system,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hosts/${hostname}/hardware-configuration.nix
    ./hosts/${hostname}/default.nix
    ./hosts/${hostname}/nvidia.nix

    # Hardware Support
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # --- 1. Home Manager Safety ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup"; # <--- Prevents install errors
    extraSpecialArgs = {
      inherit inputs username hostname system;
    };
    users."${username}" = {
      imports = [
        ./home/${username}/${hostname}/default.nix
      ];
    };
  };

  # --- 2. Stylix Theming Engine ---

  stylix = {
    enable = true;
    # Default to a nice dark theme (Catppuccin Mocha)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ashes.yaml";

    polarity = "dark";

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus";
      light = "Papirus";
    };

    # Cursor
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };

    fonts = {
      monospace = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Mono";
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      serif = {
        # Note: 'pkgs.literate' -> 'pkgs.literata' in official nixpkgs
        package = pkgs.literata;
        name = "Literata";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      # Set default sizes if you want
      sizes = {
        terminal = 10;
        applications = 10;
        desktop = 10;
      };
    };

    # We can control what stylix targets here
    targets.grub.enable = true;
    targets.console.enable = true;
  };

  # --- 3. CLI Superpowers (Comma) ---
  programs.nix-index-database.comma.enable = true;
  # Keeps the index updated automatically
  programs.command-not-found.enable = false; # Disable default to use nix-index

  # --- 4. Visual Stack ---
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember";
        user = "greeter";
      };
    };
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # System Basics
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "adbusers"];
    shell = pkgs.zsh;
  };

  # Extra fonts you wanted (Stylix adds the ones above automatically)
  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    nerd-fonts.symbols-only
    google-fonts
    noto-fonts
  ];

  system.stateVersion = "25.05";
}
