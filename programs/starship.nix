{ pkgs, ... }:

let
  # Base16 Ashes Color Palette
  # Mapped to match your previous prompt's gradient logic
  ashes = {
    red = "#C79595";      # base08
    peach = "#C7AE95";    # base09 (Orange)
    yellow = "#C7C795";   # base0A
    green = "#AEC795";    # base0B
    sapphire = "#95AEC7"; # base0D (Blue)
    lavender = "#AE95C7"; # base0E (Purple)
    text = "#C7CCD1";     # base05 (Foreground)
    crust = "#1C2023";    # base00 (Background)
  };

  # Helper function to create powerline transitions
  transition = from: to: ''[](bg:${to} fg:${from})'';

  # Define powerline symbols with proper Unicode escaping for Nix
  symbols = {
    opener = "";
    right_triangle = "";
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
      # Updated references from ${catppuccin} to ${ashes}
      format = ''
        [${symbols.opener}](${ashes.red})$os$username[${symbols.right_triangle}](fg:${ashes.red} bg:${ashes.peach})$directory[${symbols.right_triangle}](fg:${ashes.peach} bg:${ashes.yellow})$git_branch$git_status[${symbols.right_triangle}](fg:${ashes.yellow} bg:${ashes.green})$c$rust$golang$nodejs$php$java$kotlin$python[${symbols.right_triangle}](fg:${ashes.green} bg:${ashes.sapphire})$docker_context$conda[${symbols.right_triangle}](fg:${ashes.sapphire} bg:${ashes.lavender})$time[${symbols.closer}](fg:${ashes.lavender})$cmd_duration
        $character
      '';

      add_newline = false;
      right_format = "$kubernetes";

      # OS module
      os = {
        disabled = false;
        style = "bg:${ashes.red} fg:${ashes.crust}";
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
        style_user = "bg:${ashes.red} fg:${ashes.crust}";
        style_root = "bg:${ashes.red} fg:${ashes.crust}";
        format = "[ $user ]($style)";
      };

      # Directory module
      directory = {
        style = "bg:${ashes.peach} fg:${ashes.crust}";
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
        style = "bg:${ashes.yellow} fg:${ashes.crust}";
        format = "[[ $symbol $branch ](fg:${ashes.crust} bg:${ashes.yellow})]($style)";
      };

      # Git status module
      git_status = {
        style = "bg:${ashes.yellow} fg:${ashes.crust}";
        format = "[[($all_status$ahead_behind )](fg:${ashes.crust} bg:${ashes.yellow})]($style)";
      };

      # Programming language modules
      c = {
        symbol = " ";
        style = "bg:${ashes.green} fg:${ashes.crust}";
        format = "[[ $symbol( $version) ](fg:${ashes.crust} bg:${ashes.green})]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:${ashes.green} fg:${ashes.crust}";
        format = "[[ $symbol( $version) ](fg:${ashes.crust} bg:${ashes.green})]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:${ashes.green} fg:${ashes.crust}";
        format = "[[ $symbol( $version) ](fg:${ashes.crust} bg:${ashes.green})]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:${ashes.green} fg:${ashes.crust}";
        format = "[[ $symbol( $version) ](fg:${ashes.crust} bg:${ashes.green})]($style)";
      };

      php = {
        symbol = "";
        style = "bg:${ashes.green} fg:${ashes.crust}";
        format = "[[ $symbol( $version) ](fg:${ashes.crust} bg:${ashes.green})]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:${ashes.green} fg:${ashes.crust}";
        format = "[[ $symbol( $version) ](fg:${ashes.crust} bg:${ashes.green})]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:${ashes.green} fg:${ashes.crust}";
        format = "[[ $symbol( $version) ](fg:${ashes.crust} bg:${ashes.green})]($style)";
      };

      python = {
        symbol = "";
        style = "bg:${ashes.green} fg:${ashes.crust}";
        format = "[[ $symbol( $version)(\\($virtualenv\\)) ](fg:${ashes.crust} bg:${ashes.green})]($style)";
      };

      # Docker context module
      docker_context = {
        symbol = "";
        style = "bg:${ashes.sapphire} fg:${ashes.crust}";
        format = "[[ $symbol( $context) ](fg:${ashes.crust} bg:${ashes.sapphire})]($style)";
      };

      # Conda environment module
      conda = {
        symbol = "  ";
        style = "fg:${ashes.crust} bg:${ashes.sapphire}";
        format = "[$symbol$environment ]($style)";
        ignore_base = false;
      };

      # Time module
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:${ashes.lavender} fg:${ashes.crust}";
        format = "[[  $time ](fg:${ashes.crust} bg:${ashes.lavender})]($style)";
      };

      # Command duration module
      cmd_duration = {
        show_milliseconds = true;
        format = " in $duration ";
        style = "fg:${ashes.text}";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };

      # Character module
      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:${ashes.green})";
        error_symbol = "[❯](bold fg:${ashes.red})";
        vimcmd_symbol = "[❮](bold fg:${ashes.green})";
        vimcmd_replace_one_symbol = "[❮](bold fg:${ashes.lavender})";
        vimcmd_replace_symbol = "[❮](bold fg:${ashes.lavender})";
        vimcmd_visual_symbol = "[❮](bold fg:${ashes.yellow})";
      };

      # Disabled Modules
      aws = {
        disabled = true;
      };
    };
  };
}
