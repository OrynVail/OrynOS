{
  pkgs,
  userConfig,
  ...
}: {
  # Ensure thunderbird package installed
  home.packages = with pkgs; [
    thunderbird
  ];

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "app.update.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "mail.spam.manualMark" = true;
      };
    };
  };
}
