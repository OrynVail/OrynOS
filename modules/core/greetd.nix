{
  pkgs,
  lib,
  ...
}:
let
  # Mirrors monitors.lua; both change if the panel does.
  gigaDesc = "GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2";
  internal = "eDP-1";

  hyprctl = lib.getExe' pkgs.hyprland "hyprctl";

  greeterSession = pkgs.writeShellScript "greeter-session" ''
    # Giga wins and the lid panel goes dark, as in the session. Applied once, and
    # only when docked — disabling it outright leaves an undocked laptop with no greeter.
    if ${hyprctl} monitors all -j \
      | ${lib.getExe pkgs.jq} -e --arg d ${lib.escapeShellArg gigaDesc} \
          'any(.[]; .description | contains($d))' >/dev/null 2>&1; then
      ${hyprctl} keyword monitor "${internal},disable"
    fi

    ${lib.getExe pkgs.regreet}
    ${hyprctl} dispatch exit
  '';

  # Lua, not .conf: 0.56 calls hyprlang the legacy manager and says so on every start.
  greeterConf = pkgs.writeText "greeter.lua" ''
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = 1,
    })

    hl.monitor({
        output = "desc:${gigaDesc}",
        mode = "1920x1080@165.00",
        position = "0x0",
        scale = 1,
    })

    hl.on("hyprland.start", function()
        hl.exec_cmd("${greeterSession}")
    end)

    hl.config({
        animations = {
            enabled = false,
        },

        decoration = {
            blur = { enabled = false },
            shadow = { enabled = false },
        },

        misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            force_default_wallpaper = 0,
        },
    })
  '';
in
{
  services.displayManager = {
    defaultSession = "hyprland";
    regreet.enable = true;
  };

  # Not cage: single output by design, so an external monitor is a coin flip.
  # Via start-hyprland, which only relaunches on an unclean exit — the greeter's
  # own `dispatch exit` is clean, so it hands back to greetd instead of looping.
  services.greetd.settings.default_session.command =
    "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe' pkgs.hyprland "start-hyprland"} -- -c ${greeterConf}";
}
