{
  config,
  lib,
  pkgs,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.stable;
in {
  # Enable NVIDIA driver
  services.xserver.videoDrivers = ["nvidia"];

  # Kernel parameters for better Wayland and GNOME integration
  boot.kernelParams = [
    # Enable DRM kernel mode setting - required for Wayland
    "nvidia-drm.modeset=1"

    "nvidia_drm.fbdev=1"

    # Power management and performance settings
    # 0x3 = Prefer maximum performance when on AC power
    "nvidia.NVreg_RegistryDwords=PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerLevel=0x3;PowerMizerDefaultAC=0x3;RMEnableAggressiveVblank=1"
  ];

  # Environment variables for better compatibility with Wayland and GNOME
  environment.variables = {
    # Hardware video acceleration
    LIBVA_DRIVER_NAME = "nvidia";

    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # Graphics backend for Wayland
    GBM_BACKEND = "nvidia-drm";

    # Use NVIDIA driver for GLX
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Fix for hardware cursors on Wayland
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";

    # Enable G-Sync and Variable Refresh Rate if available
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    __GL_MaxFramesAllowed = "1";

    # Direct backend for NVIDIA
    NVD_BACKEND = "direct";
  };

  # NVIDIA configuration
  hardware.nvidia = {
    # Use proprietary driver for better performance
    open = false;

    # Enable NVIDIA settings utility
    nvidiaSettings = true;

    # Power management
    powerManagement = {
      # Enable power management features
      enable = false;

      # Enable fine-grained power management (turns off GPU when not in use)
      # Works well on Turing and newer GPUs like RTX 3060
      finegrained = false;
    };

    # Enable modesetting (required for Wayland)
    modesetting.enable = true;

    # Use the appropriate driver package
    package = nvidiaDriverChannel;

    prime = {
      # Offload mode - optimized for power saving
      offload = {
        enable = true;
        # Allows running specific applications on the NVIDIA GPU with `prime-run`
        enableOffloadCmd = true;
      };

      # Sync mode disabled as offload is generally better for laptops
      sync.enable = false;

      # Bus IDs for Intel and NVIDIA GPUs
      # These are generic values - we'll detect the actual values automatically
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Make lid actions inconsequential when using external monitor
  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandlePowerKey = "suspend";
        IdleAction = "suspend";
        IdleActionSec = "60min";
      };
    };
  };

  # Additional packages for hardware acceleration and debugging
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      nvidia-vaapi-driver # VAAPI support for NVIDIA
      libva-vdpau-driver # VDPAU backend for VAAPI
      libvdpau-va-gl # VDPAU implementation using VAAPI
    ];
  };

  # Additional useful packages for debugging and monitoring
  environment.systemPackages = with pkgs; [
    # GPU utilities
    vulkan-tools # Vulkan information and testing
    mesa-demos # OpenGL information
    libva-utils # VA-API debugging tools
    nvtopPackages.full # NVIDIA GPU monitoring tool

    # This creates a convenient prime-run command
    (writeShellScriptBin "prime-run" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];
}
