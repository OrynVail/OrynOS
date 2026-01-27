{
  pkgs,
  lib,
  ...
}: {
  # Ensure alacritty package installed
  home.packages = with pkgs; [
    alacritty
  ];

  # Install alacritty via home-manager module
  programs.alacritty = {
    enable = true;
    settings = {

      window = {
        decorations = "none";
        dynamic_title = false;
        dynamic_padding = true;
        dimensions = {
          columns = 170;
          lines = 45;
        };
        padding = {
          x = 5;
          y = 1;
        };
      };

      general = {
        live_config_reload = true;
      };
      
      env = {
        TERM = "xterm-256color";
      };
      
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      
      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      };
    };
  };
}