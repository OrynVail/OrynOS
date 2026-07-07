{ hostname, ... }: {
  # System Basics
  networking.hostName = hostname;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # Xserver & printing
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.printing.enable = false;

  # Programs enabled system-wide
  programs.zsh.enable = true;

  system.stateVersion = "25.05";
}
