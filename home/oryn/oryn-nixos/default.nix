{
  config,
  userConfig,
  pkgs,
  lib,
  inputs,
  hydenix,
  theme,
  userPkgs,
  username,
  hostname,
  ...
}: let
  palette = theme.colorScheme.palette;
in {
  imports = [
    ./mime.nix
    ./custom.nix
    ../../../utilities/waybar/waybar.nix
    ../../../utilities/xdg.nix
    ../../../utilities/kanshi.nix
    ../../../programs/starship.nix
    ../../../programs/firefox.nix
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
    ../../../programs/zathura.nix
    ../../../programs/obs-studio.nix
  ];

  # Home Manager basic settings
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    persepolis
    qalculate-gtk
    onlyoffice-bin
    sassc
    gimp
    kubectl
    zip
    unzip
  ];

  hydenix.hm = {
    enable = true;

    comma.enable = true; # useful nix tool to run software without installing it first
    dolphin.enable = false;
    editors = {
      enable = true;
      neovim = false;
      vscode = {
        enable = true;
        wallbash = true;
      };
      vim = false;
    };
    fastfetch.enable = false;
    firefox = {
      enable = false;
    };
    git = {
      enable = true;
      name = "Oryn Vail";
      email = "ashish_pall@outlook.com";
    };
    hyde.enable = true;
    hyprland.enable = true;
    lockscreen = {
      enable = true;
      hyprlock = true;
      swaylock = false;
    };
    notifications.enable = true;
    qt.enable = true;
    rofi.enable = true;
    screenshots = {
      enable = true;
      grim.enable = true; # screenshot tool
      slurp.enable = true; # region selection tool
      satty.enable = true; # screenshot annotation tool
      swappy.enable = false; # screenshot editor
    };
    shell = {
      enable = false;
    };
    social = {
      enable = true;
      discord.enable = true;
      webcord.enable = true;
      vesktop.enable = true;
    };
    spotify.enable = true;
    swww.enable = true;
    terminals = {
      enable = true; # enable terminals module
      kitty = {
        enable = true; # enable kitty terminal
        configText = ""; # kitty config text
      };
    };
    theme = {
      enable = true;
      active = "Catppuccin Mocha";
      themes = [
        "Catppuccin Mocha"
        "Scarlet Night"
      ]; #full list https://github.com/richen604/hydenix/tree/main/hydenix/sources/themes
    };
    waybar.enable = false;
    wlogout.enable = true;
    xdg.enable = true;
  };

  programs.home-manager.enable = true;
}
