{
  config,
  pkgs,
  ...
}: {
  services = {
    power-profiles-daemon.enable = true;

    # ACPI Daemon 
    acpid.enable = true;

    # Thermal management
    thermald.enable = true;

    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 20;
      percentageAction = 10;
      criticalPowerAction = "PowerOff";
    };
  };

  # Configure systemd sleep settings for security
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';
}