{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  pdfcraftVersion = "0.4.0";
  pdfcraftSha256 = "36942276995a78bc47aa87bf799d9f0e0c00aaf4f7f1fef06fe9f9e91923fed5";
  pdfcraftBundle = pkgs.fetchurl {
    url = "https://github.com/storytold/pdfcraft/releases/download/v${pdfcraftVersion}/pdfcraft-${pdfcraftVersion}-linux-x86_64.flatpak";
    sha256 = pdfcraftSha256;
  };
in
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    packages = [
      {
        appId = "com.obsproject.Studio";
        origin = "flathub";
      }
      # bundle, not flathub; sha256 bump forces the reinstall
      {
        appId = "ai.storyteller.pdfcraft";
        bundle = "${pdfcraftBundle}";
        sha256 = pdfcraftSha256;
      }
    ];

    uninstallUnmanaged = true;
    update.auto.enable = false;

    # egui picks the iGPU but presents to NVIDIA EGL -> black window
    overrides."ai.storyteller.pdfcraft".Environment.WGPU_POWER_PREF = "high";
  };

  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }
    {
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }
  ];

  home.packages = [ pkgs.flatpak ];

  # else .desktop exports stay invisible to the launcher
  xdg.systemDirs.data = [
    "/var/lib/flatpak/exports/share"
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  ];
}
