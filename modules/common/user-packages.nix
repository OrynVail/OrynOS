{ pkgs, ... }: {

  home.packages = with pkgs; [
    # Utils
    zip
    unzip
    sassc
    dust
    dysk
    fd

    # Applications
    gimp
    vesktop
    persepolis
    qalculate-gtk
    maxima
    wxmaxima

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
