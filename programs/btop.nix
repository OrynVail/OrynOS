{
  pkgs,
  userConfig,
  lib,
  theme,
  ...
}: {
  home.packages = with pkgs; [
    btop
  ];
  
  # Install btop via home-manager module
  programs.btop = {
    enable = true;
    settings = let
      palette = theme.colorScheme.palette;
    in {
      # Use a custom theme based on Helios colors
      color_theme = "helios";
      
      # Visual settings
      rounded_corners = true;
      vim_keys = true;
      
      # Theme colors using base16 palette
      theme_background = false;
      truecolor = true;
      force_tty = false;
      
      # Update interval and other settings
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = true;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = false;
      
      # CPU settings
      cpu_graph_upper = "total";
      cpu_graph_lower = "total";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      
      # Memory settings
      mem_graphs = true;
      mem_below_net = false;
      
      # Network settings
      net_download = 100;
      net_upload = 100;
      net_auto = true;
      net_sync = true;
      net_iface = "";
      
      # Disk settings
      show_disks = true;
      only_physical = true;
      use_fstab = false;
      zfs_arc_cached = true;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;
      io_graph_speeds = "";
      
      # Temperature settings
      check_temp = true;
      show_coretemp = true;
      temp_scale = "celsius";
      
      # Other settings
      base_10_sizes = false;
      clock_format = "/user";
      background_update = true;
      custom_cpu_name = "";
      gpu_mirror_graph = true;
      show_gpu_info = true;
      
      # Log level
      log_level = "WARNING";
    };
  };
  
  # Create custom btop theme file
  home.file.".config/btop/themes/helios.theme".text = let
    palette = theme.colorScheme.palette;
  in ''
    # Helios theme for btop
    # Main background
    theme[main_bg]="#${palette.base00}"
    
    # Main foreground  
    theme[main_fg]="#${palette.base05}"
    
    # Title color
    theme[title]="#${palette.base0D}"
    
    # Highlight color
    theme[hi_fg]="#${palette.base07}"
    
    # Selected background
    theme[selected_bg]="#${palette.base02}"
    theme[selected_fg]="#${palette.base07}"
    
    # Inactive/unfocused
    theme[inactive_fg]="#${palette.base04}"
    
    # Process colors
    theme[proc_misc]="#${palette.base0C}"
    
    # CPU colors
    theme[cpu_box]="#${palette.base0D}"
    theme[mem_box]="#${palette.base0B}"
    theme[net_box]="#${palette.base0E}"
    theme[proc_box]="#${palette.base0A}"
    theme[div_line]="#${palette.base03}"
    
    # Graph colors
    theme[temp_start]="#${palette.base0B}"
    theme[temp_mid]="#${palette.base0A}"
    theme[temp_end]="#${palette.base08}"
    
    # CPU graph gradient
    theme[cpu_start]="#${palette.base0B}"
    theme[cpu_mid]="#${palette.base0A}"
    theme[cpu_end]="#${palette.base08}"
    
    # Memory graph gradient  
    theme[free_start]="#${palette.base0C}"
    theme[free_mid]="#${palette.base0D}"
    theme[free_end]="#${palette.base0E}"
    
    theme[cached_start]="#${palette.base0A}"
    theme[cached_mid]="#${palette.base09}"
    theme[cached_end]="#${palette.base08}"
    
    theme[available_start]="#${palette.base0B}"
    theme[available_mid]="#${palette.base0C}"
    theme[available_end]="#${palette.base0D}"
    
    theme[used_start]="#${palette.base08}"
    theme[used_mid]="#${palette.base09}"
    theme[used_end]="#${palette.base0A}"
    
    # Download/Upload colors
    theme[download_start]="#${palette.base0C}"
    theme[download_mid]="#${palette.base0D}"
    theme[download_end]="#${palette.base0E}"
    
    theme[upload_start]="#${palette.base0B}"
    theme[upload_mid]="#${palette.base0A}"
    theme[upload_end]="#${palette.base09}"
    
    # Process tree colors
    theme[process_start]="#${palette.base0D}"
    theme[process_mid]="#${palette.base0C}"
    theme[process_end]="#${palette.base0B}"
  '';
}
