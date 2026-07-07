{ pkgs, inputs, ... }: {
  # Declarative Neovim packaging & desktop entry
  home.packages = [
    inputs.nvix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "kitty nvim %F";
    terminal = false;
    icon = "nvim";
    categories = [ "Utility" "TextEditor" "Development" ];
    mimeType = [ 
      "text/plain" 
      "text/x-makefile" 
      "text/x-c++hdr" 
      "text/x-c++src" 
      "text/x-chdr" 
      "text/x-csrc" 
      "text/x-java" 
      "text/x-moc" 
      "text/x-pascal" 
      "text/x-tcl" 
      "text/x-tex" 
      "application/x-shellscript" 
      "text/x-c" 
      "text/x-c++" 
    ];
  };
}
