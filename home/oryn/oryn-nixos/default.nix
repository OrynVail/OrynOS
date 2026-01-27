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

    ../../../utilities/xdg.nix
    ../../../utilities/spicetify.nix
    ../../../utilities/flatpak.nix

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
    ../../../programs/vscode.nix
  ];

  # --- Home Manager Core ---
  home.username = username;
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  # --- Packages ---
  home.packages = with pkgs; [
    zip
    unzip

    gimp
    sassc
    mangohud

    kubectl

    persepolis
    qalculate-gtk

    vesktop # Better Discord client for Linux

    papirus-icon-theme
    papirus-folders

    libsForQt5.qt5.qtwayland
    qt6.qtwayland

    firefox

    nwg-look
  ];

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
    ];
  };

  home.sessionVariables = {
  };
}
