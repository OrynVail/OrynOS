{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      maple-mono.NF
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.blex-mono
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg
      nerd-fonts.symbols-only
      google-fonts
    ];
  };
}
