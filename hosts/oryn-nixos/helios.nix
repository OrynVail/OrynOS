{ lib, pkgs, inputs, ... }:

# Helios base16 
let
  heliosPalette = {
      base00 = "1d2021";
      base01 = "383c3e";
      base02 = "53585b";
      base03 = "6f7579";
      base04 = "cdcdcd";
      base05 = "d5d5d5";
      base06 = "dddddd";
      base07 = "ffffff";
      base08 = "d72638";
      base09 = "eb8413";
      base0A = "f19d1a";
      base0B = "88b92d";
      base0C = "1ba595";
      base0D = "1e8bac";
      base0E = "be4264";
      base0F = "c85e0d";
    };
in {
  colorScheme = {
    slug = "helios";
    name = "Helios";
    author = "Oryn Vail";
    variant = "dark";
    palette = heliosPalette;
  };
  
  # Fonts
  fonts = {
     monospace = {
       name    = "IBM Plex Mono";
       package = pkgs.ibm-plex;
     };
     sansSerif = {
       name    = "Inter";
       package = pkgs.inter;
     };
     serif = {
       name    = "Literata";
       package = pkgs.literate;  
     };
     emoji = {
       name    = "Noto Color Emoji";
       package = pkgs.noto-fonts-color-emoji;
     };
   };

  # Cursor settings
  cursor = {
    name    = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size    = 20;
  };

  # Default wallpaper path
  wallpaper = ./wallpapers/helios.jpg;
  faceIcon = ./wallpapers/oryn.png;

  # System-wide font packages list
  fontPackages = with pkgs; [
    ibm-plex
    inter
    literate
    noto-fonts-color-emoji
    nerd-fonts.blex-mono
  ];
 }
