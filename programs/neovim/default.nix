{pkgs, ...}: {
  
  xdg.desktopEntries.nvim = {
  name = "Neovim";
  comment = "Edit text files";
  exec = "alacritty -e nvim %F"; 
  icon = "nvim"; 
  terminal = false; 
  categories = ["Utility" "TextEditor"];
  mimeType = ["text/plain" "text/x-python" "text/x-tex"]; 
  };
  
  # Neovim text editor configuration
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = false;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      alejandra
      black
      golangci-lint
      gopls
      gotools
      hadolint
      isort
      lua-language-server
      markdownlint-cli
      nixd
      nodePackages.bash-language-server
      nodePackages.prettier
      pyright
      ruff
      shellcheck
      shfmt
      stylua
      terraform-ls
      tflint
      vscode-langservers-extracted
      yaml-language-server
    ];
  };

  # lua config 
  xdg.configFile = {
    "nvim" = {
      source = ./lazyvim;
      recursive = true;
    };
  };
}
