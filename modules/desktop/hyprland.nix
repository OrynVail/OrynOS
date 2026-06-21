{
  pkgs,
  ...
}: {

  imports = [
  ];

  home.packages = with pkgs; [
  ];

  # Drop all the supplementary Lua modules directly into the config directory
  xdg.configFile = {
    "hypr/monitors.lua".source = ./lua/monitors.lua;
    "hypr/config.lua".source = ./lua/config.lua;
    "hypr/animations.lua".source = ./lua/animations.lua;
    "hypr/binds.lua".source = ./lua/binds.lua;
    "hypr/rules.lua".source = ./lua/rules.lua;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = ''
      ${builtins.readFile ./lua/hyprland.lua}
    '';
  };
}
