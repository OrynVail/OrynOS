{
  pkgs,
  ...
}:{
  stylix = {
    enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/ashes.yaml";

    polarity = "dark";

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus";
      light = "Papirus";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };

    fonts = {
      monospace = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Mono";
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      serif = {
        package = pkgs.literata;
        name = "Literata";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

        # Set default sizes
        sizes = {
        terminal = 10;
        applications = 10;
        desktop = 10;
      };
    };

    # targets.grub.enable = true;
    # targets.console.enable = true;
  };
}
