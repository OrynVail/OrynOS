{ hostname, ... }: {
  networking.hostName = hostname;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.printing.enable = false;

  programs.zsh.enable = true;

  system.stateVersion = "25.05";
}
