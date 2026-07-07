{
  pkgs,
  lib,
  ...
}: let
  ytMusicConfig = {
    window-size = {
      width = 1920;
      height = 1080;
    };
    window-maximized = true;
    window-position = {
      x = 0;
      y = 0;
    };
    url = "https://music.youtube.com";
    options = {
      tray = true;
      appVisible = true;
      autoUpdates = false;
      alwaysOnTop = false;
      hideMenu = false;
      hideMenuWarned = false;
      startAtLogin = false;
      disableHardwareAcceleration = false;
      removeUpgradeButton = false;
      restartOnConfigChanges = false;
      trayClickPlayPause = false;
      autoResetAppCache = false;
      resumeOnStart = false;
      likeButtons = "force";
      proxy = "";
      startingPage = "";
      overrideUserAgent = false;
      usePodcastParticipantAsArtist = false;
      themes = [];
    };
    plugins = {
      notifications.enabled = false;
      video-toggle.mode = "custom";
      precise-volume = {
        globalShortcuts = {};
        enabled = true;
      };
      discord.listenAlong = true;
      bypass-age-restrictions.enabled = true;
      sponsorblock.enabled = true;
      downloader.enabled = true;
      audio-compressor.enabled = false;
      blur-nav-bar.enabled = false;
      equalizer.enabled = false;
      ambient-mode.enabled = false;
      amuse.enabled = false;
      visualizer = {
        enabled = false;
        type = "vudio";
        butterchurn = {
          preset = "martin [shadow harlequins shape code] - fata morgana";
          renderingFrequencyInMs = 500;
          blendTimeInSeconds = 2.7;
        };
        vudio = {
          effect = "lighting";
          accuracy = 128;
          lighting = {
            maxHeight = 160;
            maxSize = 12;
            lineWidth = 1;
            color = "#49f3f7";
            shadowBlur = 2;
            shadowColor = "rgba(244,244,244,.5)";
            fadeSide = true;
            prettify = false;
            horizontalAlign = "center";
            verticalAlign = "middle";
            dottify = true;
          };
        };
        wave = {
          animations = [
            {
              type = "Cubes";
              config = {
                bottom = true;
                count = 30;
                cubeHeight = 5;
                fillColor = {
                  gradient = [
                    "#FAD961"
                    "#F76B1C"
                  ];
                };
                lineColor = "rgba(0,0,0,0)";
                radius = 20;
              };
            }
            {
              type = "Cubes";
              config = {
                top = true;
                count = 12;
                cubeHeight = 5;
                fillColor = {
                  gradient = [
                    "#FAD961"
                    "#F76B1C"
                  ];
                };
                lineColor = "rgba(0,0,0,0)";
                radius = 10;
              };
            }
            {
              type = "Circles";
              config = {
                lineColor = {
                  gradient = [
                    "#FAD961"
                    "#FAD961"
                    "#F76B1C"
                  ];
                  rotate = 90;
                };
                lineWidth = 4;
                diameter = 20;
                count = 10;
                frequencyBand = "base";
              };
            }
          ];
        };
      };
    };
    __internal__ = {
      migrations = {
        version = "3.9.0";
      };
    };
  };
in {
  # =================================================================
  #  YOUTUBE MUSIC (PEAR-DESKTOP)
  # =================================================================

  home.packages = with pkgs; [
    pear-desktop
  ];

  # --- CONFIGURATION SETUP ---
  # Using activation scripts to ensure the config is present without making it read-only.
  # Note: The config directory remains "YouTube Music" as that's where the app looks.
  home.activation.setupYoutubeMusic = lib.mkAfter ''
    CONFIG_DIR="$HOME/.config/YouTube Music"
    CONFIG_FILE="$CONFIG_DIR/config.json"
    mkdir -p "$CONFIG_DIR"

    if ! [ -f "$CONFIG_FILE" ]; then
      echo "YouTube Music config.json not found. Creating initial config..."
      echo '${builtins.toJSON ytMusicConfig}' > "$CONFIG_FILE"
    fi
  '';

  # --- DESKTOP INTEGRATION ---
  # We create a custom desktop entry so it shows up as "YouTube Music"
  # but executes the "pear-desktop" binary.
  xdg.desktopEntries = {
    "com.github.th_ch.youtube_music" = {
      name = "YouTube Music";
      type = "Application";
      exec = "pear-desktop %u";
      icon = "pear-desktop";
      terminal = false;
      categories = ["AudioVideo"];
      mimeType = ["x-scheme-handler/youtubemusic"];
    };
  };
}
