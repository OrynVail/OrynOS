{ pkgs, ... }: {
  # Enable and configure yt-dlp via Home Manager module
  programs.yt-dlp = {
    enable = true;
  };
}
