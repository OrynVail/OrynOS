{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    # Core Tools
    wget
    curl
    git

    # Dev
    gcc
    nodejs
    python3

    # Utils
    wmctrl
    eza
    tree
    mc
    killall
    gpu-screen-recorder
    grim
    slurp

    qt6.qtwayland

    trezor-suite
    python313Packages.trezor
  ];
}
