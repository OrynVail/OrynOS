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
    # A repeated --enable/--disable-features discards every earlier one, so these
    # stay single lists and carry the wrapper's values too.
    commandLineArgs = [
      "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization,WebUIDarkMode,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,WaylandWindowDecorations"
      "--disable-features=UseChromeOSDirectVideoDecoder,MediaRouter,OptimizationHints,WaylandWpColorManagerV1,OutdatedBuildDetector"

      # Wayland Native
      "--ozone-platform=wayland"

      # Hardware Acceleration (NVIDIA optimized)
      "--enable-accelerated-video-decode"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"

      # Privacy & Security
      "--disable-background-networking" # No telemetry
      "--disable-sync" # Manual sync control

      # UI/UX
      "--force-dark-mode" # Match Stylix theme
    ];
  };

  # =================================================================
  #  SYSTEM INTEGRATION
  # =================================================================

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
