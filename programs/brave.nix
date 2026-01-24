{
  pkgs,
  config,
  ...
}: {
  # =================================================================
  #  BRAVE - CHROMIUM-BASED SOVEREIGNTY
  # =================================================================

  programs.brave = {
    enable = true;
    package = pkgs.brave;

    # --- EXTENSIONS (Chrome Web Store IDs) ---
    extensions = [
      # Security & Privacy
      {id = "epcnnfbjfcgphgdmggkamkmgojdagdnn";} # uBlock Origin
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";} # Privacy Badger

      # Productivity
      {id = "cgfpgnepljlgenjclbekbjdlgcodfmjp";} # Simple Tab Groups
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # Vimium

      # Content Enhancement
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
      {id = "oldceeleldhonbafppcapldpdifcinji";} # LanguageTool
      {id = "iplffkdpngmdjhlpjmppncnlhomiipha";} # Unpaywall

      # Utilities
      {id = "bhmmomiinigofkjcapegjjndpbikblnp";} # I Still Don't Care About Cookies
      {id = "cimiefiiaegbelhefglklhhakcgmhkai";} # Link Cleaner (alternative: ClearURLs)

      # YouTube Enhancements
      {id = "gebbhagfogifgggkldgodflihgfeippi";} # Return YouTube Dislike
    ];

    # --- COMMAND LINE FLAGS (Performance + Privacy) ---
    commandLineArgs = [
      # Wayland Native
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"

      # Hardware Acceleration (NVIDIA optimized)
      "--enable-accelerated-video-decode"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"

      # Performance
      "--enable-features=VaapiVideoDecoder"
      "--enable-features=VaapiVideoEncoder"
      "--enable-features=CanvasOopRasterization"
      "--disable-features=UseChromeOSDirectVideoDecoder"

      # Privacy & Security
      "--disable-features=MediaRouter" # Disable Chromecast
      "--disable-features=OptimizationHints" # No Google suggestions
      "--disable-background-networking" # No telemetry
      "--disable-sync" # Manual sync control

      # Wayland-specific fixes
      "--disable-features=WaylandWpColorManagerV1" # Color management fix

      # UI/UX
      "--force-dark-mode" # Match Stylix theme
      "--enable-features=WebUIDarkMode"
    ];
  };

  # =================================================================
  #  SYSTEM INTEGRATION
  # =================================================================

  # Set Brave as default browser
  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
    "application/xhtml+xml" = "brave-browser.desktop";
  };

  # Session variables
  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
    BROWSER = "${pkgs.brave}/bin/brave";
  };

  # =================================================================
  #  BRAVE SETTINGS (via brave://flags)
  # =================================================================

  # These need to be set manually in brave://flags on first launch:
  # - Enable Tab Groups (UI)
  # - Enable Parallel Downloading
  # - Enable Reader Mode
  # - GPU Rasterization: Enabled
  # - Override software rendering list: Enabled
  #
  # Privacy settings (brave://settings/privacy):
  # - Block trackers & ads: Aggressive
  # - Block all fingerprinting
  # - Upgrade connections to HTTPS
  # - Block scripts: Off (breaks sites, use uBlock instead)
  # - Block cookies: Only 3rd party
  #
  # Appearance (brave://settings/appearance):
  # - Show home button: Off
  # - Show bookmarks bar: Only on new tab
  # - Use wide address bar: On
}
