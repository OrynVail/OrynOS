{
  pkgs,
  userConfig,
  lib,
  theme,
  ...
}: {
  # Ensure alacritty package installed
  home.packages = with pkgs; [
    alacritty
  ];

  # Install alacritty via home-manager module
  programs.alacritty = {
    enable = true;
    settings = let
      palette = theme.colorScheme.palette;
    in {
      font = {
        size = 11.0; # Set the font size

        normal = {
          # The font family name must be a string (in quotes)
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Regular";
        };

        bold = {
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Bold";
        };

        italic = {
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Italic";
        };
      };

      colors = {
        primary = {
          # background = "#${palette.base00}";
          foreground = "#${palette.base05}";
        };

        normal = {
          black = "#${palette.base00}";
          red = "#${palette.base08}";
          green = "#${palette.base0B}";
          yellow = "#${palette.base0A}";
          blue = "#${palette.base0D}";
          magenta = "#${palette.base0E}";
          cyan = "#${palette.base0C}";
          white = "#${palette.base05}";
        };

        bright = {
          black = "#${palette.base03}";
          red = "#${palette.base08}";
          green = "#${palette.base0B}";
          yellow = "#${palette.base0A}";
          blue = "#${palette.base0D}";
          magenta = "#${palette.base0E}";
          cyan = "#${palette.base0C}";
          white = "#${palette.base07}";
        };
      };

      window = {
        decorations =
          if pkgs.stdenv.isDarwin
          then "buttonless"
          else "none";
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
