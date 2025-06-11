{ pkgs, theme, ... }: 

let
  # Define Catppuccin Mocha colors
  # We'll use these for the powerline segments
  catppuccin = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };

  # Helper function to create powerline transitions
  transition = from: to: ''[](bg:${to} fg:${from})'';
  
  # Use Helios palette for specific elements if needed
  palette = theme.colorScheme.palette;

  # Define powerline symbols with proper Unicode escaping for Nix
  symbols = {
    # Opener
    opener = "";
    
    # Right-pointing triangle
    right_triangle = "";
    
    # closer
    closer = "";
  };
in {
  home.packages = with pkgs; [
    starship
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # Format string with powerline transitions
      format = ''
        [${symbols.opener}](${catppuccin.red})$os$username[${symbols.right_triangle}](fg:${catppuccin.red} bg:${catppuccin.peach})$directory[${symbols.right_triangle}](fg:${catppuccin.peach} bg:${catppuccin.yellow})$git_branch$git_status[${symbols.right_triangle}](fg:${catppuccin.yellow} bg:${catppuccin.green})$c$rust$golang$nodejs$php$java$kotlin$python[${symbols.right_triangle}](fg:${catppuccin.green} bg:${catppuccin.sapphire})$docker_context$conda[${symbols.right_triangle}](fg:${catppuccin.sapphire} bg:${catppuccin.lavender})$time[${symbols.closer}](fg:${catppuccin.lavender})$cmd_duration
        $character
      '';

      # False: The format string handles the newline before the prompt character
      add_newline = false;

      # Right side prompt - keep kubernetes from original config
      right_format = "$kubernetes";

      # OS module
      os = {
        disabled = false;
        style = "bg:${catppuccin.red} fg:${catppuccin.crust}";
        symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          NixOS = "󱄅";
        };
      };

      # Username module
      username = {
        show_always = true;
        style_user = "bg:${catppuccin.red} fg:${catppuccin.crust}";
        style_root = "bg:${catppuccin.red} fg:${catppuccin.crust}";
        format = "[ $user ]($style)";
      };

      # Directory module
      directory = {
        style = "bg:${catppuccin.peach} fg:${catppuccin.crust}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      # Git branch module
      git_branch = {
        symbol = "";
        style = "bg:${catppuccin.yellow} fg:${catppuccin.crust}";
        format = "[[ $symbol $branch ](fg:${catppuccin.crust} bg:${catppuccin.yellow})]($style)";
      };

      # Git status module
      git_status = {
        style = "bg:${catppuccin.yellow} fg:${catppuccin.crust}";
        format = "[[($all_status$ahead_behind )](fg:${catppuccin.crust} bg:${catppuccin.yellow})]($style)";
      };

      # Programming language modules
      c = {
        symbol = " ";
        style = "bg:${catppuccin.green} fg:${catppuccin.crust}";
        format = "[[ $symbol( $version) ](fg:${catppuccin.crust} bg:${catppuccin.green})]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:${catppuccin.green} fg:${catppuccin.crust}";
        format = "[[ $symbol( $version) ](fg:${catppuccin.crust} bg:${catppuccin.green})]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:${catppuccin.green} fg:${catppuccin.crust}";
        format = "[[ $symbol( $version) ](fg:${catppuccin.crust} bg:${catppuccin.green})]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:${catppuccin.green} fg:${catppuccin.crust}";
        format = "[[ $symbol( $version) ](fg:${catppuccin.crust} bg:${catppuccin.green})]($style)";
      };

      php = {
        symbol = "";
        style = "bg:${catppuccin.green} fg:${catppuccin.crust}";
        format = "[[ $symbol( $version) ](fg:${catppuccin.crust} bg:${catppuccin.green})]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:${catppuccin.green} fg:${catppuccin.crust}";
        format = "[[ $symbol( $version) ](fg:${catppuccin.crust} bg:${catppuccin.green})]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:${catppuccin.green} fg:${catppuccin.crust}";
        format = "[[ $symbol( $version) ](fg:${catppuccin.crust} bg:${catppuccin.green})]($style)";
      };

      python = {
        symbol = "";
        style = "bg:${catppuccin.green} fg:${catppuccin.crust}";
        format = "[[ $symbol( $version)(\\($virtualenv\\)) ](fg:${catppuccin.crust} bg:${catppuccin.green})]($style)";
      };

      # Docker context module
      docker_context = {
        symbol = "";
        style = "bg:${catppuccin.sapphire} fg:${catppuccin.crust}";
        format = "[[ $symbol( $context) ](fg:${catppuccin.crust} bg:${catppuccin.sapphire})]($style)";
      };

      # Conda environment module
      conda = {
        symbol = "  ";
        style = "fg:${catppuccin.crust} bg:${catppuccin.sapphire}";
        format = "[$symbol$environment ]($style)";
        ignore_base = false;
      };

      # Time module
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:${catppuccin.lavender} fg:${catppuccin.crust}";
        format = "[[  $time ](fg:${catppuccin.crust} bg:${catppuccin.lavender})]($style)";
      };

      # Command duration module
      cmd_duration = {
        show_milliseconds = true;
        format = " in $duration ";
        style = "fg:${catppuccin.text}";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };

      # Character module
      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:${catppuccin.green})";
        error_symbol = "[❯](bold fg:${catppuccin.red})";
        vimcmd_symbol = "[❮](bold fg:${catppuccin.green})";
        vimcmd_replace_one_symbol = "[❮](bold fg:${catppuccin.lavender})";
        vimcmd_replace_symbol = "[❮](bold fg:${catppuccin.lavender})";
        vimcmd_visual_symbol = "[❮](bold fg:${catppuccin.yellow})";
      };

      # Keep kubernetes from original config
      kubernetes = {
        symbol = "󱃾 ";
        style = "fg:${palette.base0C} bold";
        format = ''[$symbol$context( \($namespace\) )]($style)'';
        contexts = [
          {
            context_pattern = "arn:aws:eks:(?P<var_region>.*):(?P<var_account>[0-9]{12}):cluster/(?P<var_cluster>.*)";
            context_alias = "$var_cluster";
          }
        ];
      };

      # Disabled Modules
      aws = {
        disabled = true; # From original config
      };
    };
  };
}
