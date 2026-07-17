{
  username,
  self,
  ...
}: {
  imports = [
    # modules
    "${self}/modules/desktop/hyprland.nix"
    "${self}/modules/desktop/mime.nix"
    "${self}/modules/nix/flatpak.nix"

    # programs
    "${self}/modules/programs/bat.nix"
    "${self}/modules/programs/brave.nix"
    "${self}/modules/programs/btop.nix"
    "${self}/modules/programs/documents.nix"
    "${self}/modules/programs/fastfetch.nix"
    "${self}/modules/programs/fzf.nix"
    "${self}/modules/programs/gemini.nix"
    "${self}/modules/programs/git.nix"
    "${self}/modules/programs/gpg.nix"
    "${self}/modules/programs/k9s.nix"
    "${self}/modules/programs/kitty.nix"
    "${self}/modules/programs/krew.nix"
    "${self}/modules/programs/lazygit.nix"
    "${self}/modules/programs/mangohud.nix"
    "${self}/modules/programs/mpv.nix"
    "${self}/modules/programs/neovim.nix"
    "${self}/modules/programs/obsidian.nix"
    "${self}/modules/programs/satty.nix"
    "${self}/modules/programs/spicetify.nix"
    "${self}/modules/programs/starship.nix"
    "${self}/modules/programs/thunderbird.nix"
    "${self}/modules/common/user-packages.nix"
    "${self}/modules/programs/vscode.nix"
    "${self}/modules/programs/yt-dlp.nix"
    "${self}/modules/programs/ytmusic.nix"
    "${self}/modules/programs/zathura.nix"
    "${self}/modules/programs/zsh.nix"
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.pointerCursor.enable = true;
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  home.sessionVariables = {
  };
}
