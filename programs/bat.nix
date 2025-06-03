{ pkgs, ...}: {

 home.packages = with pkgs; [
    bat
  ];
  
  # Install bat via home-manager module
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };
}

