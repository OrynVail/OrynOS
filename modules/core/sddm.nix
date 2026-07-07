{ pkgs, lib, ... }:

let
  clockworkTheme = pkgs.stdenv.mkDerivation {
    name = "clockwork";
    src = ../../themes/clockwork;

    installPhase = ''
      mkdir -p $out/share/sddm/themes/clockwork
      cp -aR $src/* $out/share/sddm/themes/clockwork/
    '';
  };

  sddmDependencies = with pkgs.kdePackages; [
    qt5compat
    qtdeclarative
    qtmultimedia
    qtsvg
    qtvirtualkeyboard
  ];
in
{
  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;

      wayland = {
        enable = true;
        compositor = "kwin";
      };

      package = pkgs.kdePackages.sddm;
      theme = "clockwork";
      extraPackages = sddmDependencies;

      settings = {
        Theme = {
          CursorTheme = "Bibata-Modern-Classic";
        };
      };
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;

  environment.systemPackages = [
    clockworkTheme
    pkgs.bibata-cursors
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "20";
  };
}
