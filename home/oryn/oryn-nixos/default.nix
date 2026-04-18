{
  pkgs,
  username,
  config,
  inputs,
  self,
  ...
}: {
  imports = [
    ./custom.nix

    # modules
    "${self}/modules/desktop/hyprland.nix"
    "${self}/modules/nix/flatpak.nix"
    "${self}/modules/desktop/mime.nix"

    # programs
    "${self}/programs/bat.nix"
    "${self}/programs/brave.nix"
    "${self}/programs/btop.nix"
    "${self}/programs/fastfetch.nix"
    "${self}/programs/fzf.nix"
    "${self}/programs/gemini.nix"
    "${self}/programs/gpg.nix"
    "${self}/programs/k9s.nix"
    "${self}/programs/kitty.nix"
    "${self}/programs/krew.nix"
    "${self}/programs/lazygit.nix"
    "${self}/programs/mpv.nix"
    "${self}/programs/obs-studio.nix"
    "${self}/programs/obsidian.nix"
    "${self}/programs/satty.nix"
    #"${self}/programs/spicetify.nix"
    "${self}/programs/starship.nix"
    "${self}/programs/thunderbird.nix"
    "${self}/programs/vscode.nix"
    "${self}/programs/ytmusic.nix"
    "${self}/programs/zathura.nix"
    "${self}/programs/zsh.nix"
  ];

  # --- Home Manager Core ---
  home.username = username;
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  # --- Packages ---
  home.packages = with pkgs; [
    inputs.nvix.packages.${pkgs.stdenv.hostPlatform.system}.default
    zip
    unzip

    gimp
    sassc
    mangohud

    kubectl

    persepolis
    qalculate-gtk
    yt-dlp

    vesktop

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
