{
  pkgs,
  username,
  config,
  inputs,
  ...
}: {
  imports = [
    ./mime.nix
    ./hyprland.nix
    ./custom.nix

    ../../../utilities/spicetify.nix
    ../../../utilities/flatpak.nix

    ../../../programs/starship.nix
    ../../../programs/brave.nix
    ../../../programs/thunderbird.nix
    ../../../programs/zsh.nix
    ../../../programs/fzf.nix
    ../../../programs/alacritty.nix
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
    ../../../programs/ytmusic.nix
    ../../../programs/kitty.nix
  ];

  # --- Home Manager Core ---
  home.username = username;
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  # --- Packages ---
  home.packages = with pkgs; [
    inputs.nvix.packages.${pkgs.system}.full
    zip
    unzip

    gimp
    sassc
    mangohud

    kubectl

    persepolis
    qalculate-gtk
    yt-dlp

    mullvad-browser

    vesktop # Better Discord client for Linux

    papirus-icon-theme
    papirus-folders

    libsForQt5.qt5.qtwayland
    qt6.qtwayland
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

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
  };

  home.sessionVariables = {
  };
}
