{
  self,
  ...
}: {
  imports = [
    # core
    "${self}/modules/core/audio.nix"
    "${self}/modules/core/boot.nix"
    "${self}/modules/core/network.nix"
    "${self}/modules/core/power.nix"
    "${self}/modules/core/security.nix"
    "${self}/modules/core/sddm.nix"
    "${self}/modules/core/system.nix"
    "${self}/modules/core/users.nix"

    # desktop
    "${self}/modules/desktop/fonts.nix"
    "${self}/modules/desktop/gnome.nix"
    "${self}/modules/desktop/hyprland-system.nix"
    "${self}/modules/desktop/stylix.nix"

    # hardware
    "${self}/modules/hardware/hardware.nix"

    # nix
    "${self}/modules/nix/nh.nix"
    "${self}/modules/nix/settings.nix"

    # programs
    "${self}/modules/programs/torrent.nix"

    ./system-packages.nix
  ];
}
