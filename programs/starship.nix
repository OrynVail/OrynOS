{ pkgs, theme, ... }: {

  home.packages = with pkgs; [
    starship
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = let
      palette = theme.colorScheme.palette;
    in {
      # False: The \n in the format string handles the newline before the prompt character.
      add_newline = false;

      # Right side prompt
      right_format = "$kubernetes";

       directory = {
        style = "bold #${palette.base08}";
      };

      git_branch = {
        symbol = "";
        style = "fg:${palette.base07} bg:${palette.base0D}"; # White text on Blue BG (base0D)
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "fg:${palette.base07} bg:${palette.base0D}"; # White text on Blue BG (base0D)
        format = "[($all_status$ahead_behind )]($style)";
      };
      
      docker_context = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol$context ]($style)";
      };

      golang = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      helm = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      gradle = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      java = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      kotlin = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      lua = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      nodejs = {
        symbol = ""; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      package = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      php = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      python = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      rust = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol($version) ]($style)";
      };

      terraform = {
        symbol = " "; 
        style = "fg:${palette.base07} bg:${palette.base0E}";
        format = "[ $symbol$workspace ]($style)";
      };
      
      kubernetes = {
        symbol = "󱃾 "; 
        style = "fg:${palette.base0C} bold"; 
        format = ''[$symbol$context( \($namespace\) )]($style)''; 
        # disabled = false; # Default behavior
        contexts = [ 
          {
            context_pattern = "arn:aws:eks:(?P<var_region>.*):(?P<var_account>[0-9]{12}):cluster/(?P<var_cluster>.*)";
            context_alias = "$var_cluster";
          }
        ];
      };

      # Disabled Modules
      aws = {
        disabled = true; # From your config
      };
    };
  };
}