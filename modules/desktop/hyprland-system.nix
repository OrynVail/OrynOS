{ pkgs, username, lib, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.gpu-screen-recorder.enable = true;

  # Polkit
  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Shell managed by UWSM
  systemd.user.services.ambxst = {
    description = "Ambxst Desktop Visual Shell";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    environment = {
      PATH = lib.mkForce "/home/${username}/.nix-profile/bin:/home/${username}/.local/bin:/run/current-system/sw/bin";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.uwsm}/bin/uwsm app -- ambxst";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}
