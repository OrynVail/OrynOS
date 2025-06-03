{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode 
  ];

  # Patch the .desktop file for vscode
  xdg.desktopEntries.code = {
    name = "vscode";
    exec = "code"; 
    icon = "code"; 
    terminal = false;
    type = "Application";
    categories = [ "Development" "IDE" ];
  };
}
