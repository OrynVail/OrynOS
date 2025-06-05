{
  pkgs,
  userConfig,
  ...
}: {
  # Ensure fastfetch package installed
  home.packages = with pkgs; [
    fastfetch
  ];

  # Install and configure fastfetch via home-manager module
  programs.fastfetch = {
    enable = true;
    settings = {
      # Logo Configuration
      logo = {
        source = ../themes/OrynOS.png;
        height = 25;
        #color = {
        #  "1" = "red";  
        # };
        padding = {
          top = 2; 
        };
      };

      # Global Display Settings - Oryn's aesthetic palette
      display = {
        separator = " ➜ "; 
        color = {
          keys = "red";     
          separator = "red"; 
        };
      };

      # Module Configuration 
      modules = [
        # Title with custom format
        {
          type = "title";
          format = " {8} "; 
          color = {
            host = "red";
          };
        }
        
        # Philosophical opener
        {
          type = "custom";
          format = " \"The machine remembers what you've forgotten\" ";
          color = "white";
        }
        
        "break"
        
        # System Core - The Foundation
        {
          type = "custom";
          format = "╭─ System Foundation ";
          color = "white";
        }
        
        {
          key = " ├   ";
          keyColor = "red";
          type = "os";
          format = "{name} {version} {arch}";
        }
        
        {
          key = " ├ 󰌢  ";
          keyColor = "red"; 
          type = "host";
          format = "{name} {version}";
        }
        
        {
          key = " ├ 󰘳  ";
          keyColor = "red";
          type = "kernel";
        }
        
        {
          key = " ├ 󰔚  ";
          keyColor = "red";
          type = "uptime";
          format = "{days}d {hours}h {minutes}m";
        }
        
        "break"
        
        # Hardware Inventory - The Arsenal  
        {
          type = "custom";
          format = "├─ Hardware Arsenal ";
          color = "white";
        }
        
        {
          key = " ├ 󰻠  ";
          keyColor = "red";
          type = "cpu";
          format = "{name} │ {cores-physical}C/{cores-logical}T @ {freq-max}";
        }
        
        {
          key = " ├ 󰍛  ";
          keyColor = "red";
          type = "gpu";
        }
        
        {
          key = " ├ 󰑭  ";
          keyColor = "red";
          type = "memory";
           percent = {
            type = 3;  # Custom bar
            barWidth = 10;
            charElapsed = "█";
            charTotal = "░";
          };
        }
        
        {
          key = " ├ 󰋊  ";
          keyColor = "red";
          type = "disk";
        }
        
        "break"
        
        # Software Stack - The Tools
        {
          type = "custom";
          format = "├─ Software Stack ";
          color = "white";
        }
        
        {
          key = " ├ 󰏖  ";
          keyColor = "red";
          type = "packages";
        }
        
        {
          key = " ├ 󰖟  ";
          keyColor = "red";
          type = "display";
          compactType = "original-with-refresh-rate";
          format = "{width}x{height} @ {refresh-rate}Hz │ {scaling}x";
        }
        
        {
          key = " ├ 󰨇  ";
          keyColor = "red";
          type = "de";
        }
        
        {
          key = " ├ 󰖲  ";
          keyColor = "red";
          type = "wm";
        }
        
        {
          key = " ├ 󰆍  ";
          keyColor = "red";
          type = "shell";
        }
        
        {
          key = " ├ 󰆍  ";
          keyColor = "red";
          type = "terminal";
        }
        
        "break"
        
        # Network Intelligence - The Connections
        {
          type = "custom";
          format = "├─ Network Presence ";
          color = "white";
        }
        
        {
          key = " ├ 󰩟  ";
          keyColor = "red";
          type = "localip";
          format = "{ifname}: {ipv4}";
        }
        
        "break"
        
        # signature
        {
          type = "custom";
          format = " OrynOS ─ \"Truth through transparency\" ";
          color = "red";
        }

        "break"

        # Color palette showcase 
        {
          type = "colors";
          paddingLeft = 25;
          symbol = "circle"; 
          width = 4;
          height = 1;
        }             
      ];
    };
  };
}
