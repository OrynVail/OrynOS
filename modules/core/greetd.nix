{
  ...
}:
{
  services.displayManager = {
    defaultSession = "hyprland";

    regreet = {
      enable = true;
      # Docked with the lid shut, so last-connected is the external. -s keeps
      # VT switching — the way back in.
      cageArgs = [
        "-s"
        "-d"
        "-m"
        "last"
      ];
    };
  };
}
