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
    settings = {
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
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };

        normal = {
          black = "#1e1e2e";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#eba0ac";
          cyan = "#89dceb";
          white = "#f5e0dc";
        };

        bright = {
          black = "#313244";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#eba0ac";
          cyan = "#89dceb";
          white = "#f5e0dc";
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
