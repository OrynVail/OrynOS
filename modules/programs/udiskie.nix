{ ... }:
{
  # Automount removable drives through udisks2 (enabled in desktop/services.nix)
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
    settings.device_config = [
      # Internal disks are mounted by fstab or not at all
      {
        is_external = false;
        ignore = true;
      }
    ];
  };
}
