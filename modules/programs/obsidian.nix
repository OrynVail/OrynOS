{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (obsidian.override { electron = electron_44; })
  ];

  # Patch the .desktop file for Obsidian
  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    exec = "obsidian";
    icon = "obsidian";
    terminal = false;
    type = "Application";
    categories = [
      "Office"
      "Utility"
    ];
  };
}
