{ pkgs, ... }: {

  home.packages = with pkgs; [
    # Utils
    zip
    unzip
    sassc

    # Applications
    gimp
    vesktop
    obs-studio
    persepolis
    qalculate-gtk

    # Kubernetes
    kubectl

    # Themes
    papirus-icon-theme
    papirus-folders

    # System
    qt5.qtwayland
    qt6.qtwayland
  ];
}
