{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    file-roller
    loupe
    gvfs
    seahorse
  ];

  # Trash, mounting and network shares for the TUI file managers
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # MTP automount
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_MTP_DEVICE}=="1", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="mtp-automount.service"
  '';

  systemd.user.services.mtp-automount = {
    description = "Mount MTP devices through gvfs";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "mtp-automount";
          runtimeInputs = with pkgs; [
            glib
            gnugrep
            gnused
            coreutils
          ];
          text = ''
            for _ in $(seq 60); do
              found=0
              pending=0
              for root in $(gio mount -li | sed -n 's|.*activation_root=\(mtp://.*\)|\1|p'); do
                found=1
                gio mount -l | grep -qF -- "-> $root" && continue
                gio mount "$root" 2>/dev/null || pending=1
              done
              [ "$found" = 1 ] && [ "$pending" = 0 ] && exit 0
              sleep 2
            done
          '';
        }
      );
      TimeoutStartSec = 150;
    };
  };

  # Enable security services
  programs.dconf.enable = true;
}
