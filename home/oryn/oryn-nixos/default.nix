{
  pkgs,
  username,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./mime.nix
    ./hyprland.nix
    ./custom.nix

    # --- Absolute Imports (Robust) ---
    ../../../utilities/xdg.nix
    ../../../utilities/kanshi.nix
    ../../../utilities/spicetify.nix
    ../../../utilities/flatpak.nix

    # --- Programs ---
    ../../../programs/starship.nix
    ../../../programs/brave.nix
    ../../../programs/thunderbird.nix
    ../../../programs/zsh.nix
    ../../../programs/fzf.nix
    ../../../programs/alacritty.nix
    ../../../programs/neovim
    ../../../programs/obsidian.nix
    ../../../programs/k9s.nix
    ../../../programs/krew.nix
    ../../../programs/btop.nix
    ../../../programs/gpg.nix
    ../../../programs/bat.nix
    ../../../programs/lazygit.nix
    ../../../programs/mpv.nix
    ../../../programs/fastfetch.nix
    ../../../programs/obs-studio.nix
    ../../../programs/zathura.nix
  ];

  # --- Home Manager Core ---
  home.username = username;
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  # --- Packages ---
  home.packages = with pkgs; [
    # Utilities
    zip
    unzip
    wlogout # Was enabled in hydenix

    # Graphics/Media
    gimp
    sassc
    mangohud

    # Dev/Cloud
    kubectl

    # Tools
    persepolis
    qalculate-gtk

    # Social (Replaces Hydenix module)
    vesktop # Better Discord client for Linux

    papirus-icon-theme
    papirus-folders

    firefox

    nwg-look
  ];

  # --- Ported Configurations ---

  # Git Identity
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Oryn Vail";
        email = "orynvail@gmail.com";
      };
    };
  };

  # VSCode
  programs.vscode = {
    enable = true;
  };

  # Terminal
  programs.kitty = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
  };

  stylix.targets.firefox = {
    enable = true;
    profileNames = [
      "default"
      "chatroulette"
      "demo"
      "sxm"
    ];
  };

  home.sessionVariables = {
  };
}
