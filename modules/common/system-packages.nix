{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    wget
    curl
    git

    gcc
    nodejs
    python3

    proton-vpn

    wmctrl
    wl-clipboard
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
