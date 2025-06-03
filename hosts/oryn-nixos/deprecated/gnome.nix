{ pkgs, ... }:

{
  # Enable GNOME
  services.xserver.desktopManager.gnome.enable = true;

  # Remove decorations for QT applications on Wayland
  # This helps with consistent theming for some Qt apps under GNOME Wayland.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Older variable, might not be needed for all apps
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Disables client-side decorations for Qt apps on Wayland
  };

  # Excluding some default GNOME applications
  # Users can uncomment or add packages they wish to exclude from the default GNOME installation.
  environment.gnome.excludePackages = with pkgs; [
    gnome-connections     # Remote desktop client
    gnome-console         # Simple terminal, user might prefer gnome-terminal or other
    gnome-photos          # Photo manager
    gnome-tour            # Introduction to GNOME features
    snapshot              # Screenshot tool (GNOME now has a built-in one with PrintScreen)
    atomix                # Puzzle game
    cheese                # Webcam tool
    epiphany              # GNOME Web browser
    evince                # Document viewer (PDF, etc.) - user might have alternatives or prefer this
    geary                 # Email reader
    gnome-contacts        # Contacts manager
    gnome-maps            # Maps application
    gnome-music           # Music player
    gnome-system-monitor
    gnome-weather
    gnome-calculator
    simple-scan
    totem               # Video player
    # gnome-software      # Software center, less used with NixOS package management
    # Add other packages to exclude as needed
  ];

  # Example: Enable specific GNOME extensions if desired
  # environment.systemPackages = with pkgs; [
  #   gnomeExtensions.appindicator # Example extension
  # ];

  # Further GNOME specific settings can be added here.
  # For example, dconf settings for GNOME can be managed via home-manager for user-specific settings,
  # or system-wide defaults could be attempted here if applicable (though less common for deep UI tweaks).
}

