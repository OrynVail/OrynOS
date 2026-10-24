{
  pkgs,
  lib,
  config,
  ...
}:
let
  c = config.lib.stylix.colors.withHashtag;
  hex = config.lib.stylix.colors;
  tuigreet = lib.getExe' pkgs.tuigreet "tuigreet";

  settings = {
    # Not sessions_dirs: the hyprland package ships a uwsm entry too.
    session.command = lib.getExe' config.programs.hyprland.package "start-hyprland";

    display = {
      show_time = true;
      time_format = "%A %d %B  %H:%M";
      battery = true;
    };

    remember.username = true;

    secret = {
      mode = "characters";
      characters = "•";
    };

    layout = {
      width = 52;
      container_padding = 2;
      prompt_padding = 1;

      # Empty or a bare store path under session.command.
      widgets.status_bar = {
        show_command = false;
        show_session = false;
        show_session_status = false;
        show_background = false;
      };
    };

    power = {
      shutdown = "systemctl poweroff";
      reboot = "systemctl reboot";
    };

    theme = {
      container = c.base00;
      border = c.base0F;
      title = c.base0F;
      time = c.base0F;
      button = c.base0F;
      text = c.base05;
      greet = c.base05;
      input = c.base05;
      prompt = c.base0A;
      action = c.base0B;
    };
  };

  # theme.container only fills the box; foot paints around it. 1.28 split
  # the palette into dark/light variants, so set both.
  footConfig = pkgs.writeText "greeter-foot.ini" ''
    font=monospace:size=14

    [colors-dark]
    background=${hex.base00}
    foreground=${hex.base05}

    [colors-light]
    background=${hex.base00}
    foreground=${hex.base05}
  '';

  toml = (pkgs.formats.toml { }).generate "tuigreet.toml" settings;

  # tuigreet drops unknown keys silently, so parse it at build time.
  checked = pkgs.runCommand "tuigreet-config.toml" { } ''
    ${tuigreet} --config ${toml} --dump-config </dev/null >dump 2>&1 || true
    if grep -q '^error:' dump; then cat dump; exit 1; fi
    cp ${toml} $out
  '';
in
{
  environment.etc."tuigreet/config.toml".source = checked;

  services.greetd = {
    enable = true;

    # tuigreet is a TUI, so it takes a terminal, and cage to aim it — the VT
    # console is on the iGPU (eDP-1), dark with the lid shut. -s keeps VT switching.
    settings.default_session.command = lib.concatStringsSep " " [
      "${lib.getExe' pkgs.cage "cage"} -s -d -m last --"
      "${lib.getExe' pkgs.foot "foot"} -c ${footConfig} --term=xterm-256color"
      tuigreet
    ];
  };
}
