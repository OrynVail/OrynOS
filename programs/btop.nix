{
  pkgs,
  userConfig,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    btop
  ];
  
  # Install btop via home-manager module
  programs.btop = {
    enable = true;
    settings = {
      
      # Visual settings
      rounded_corners = true;
      vim_keys = true;
      
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
}
