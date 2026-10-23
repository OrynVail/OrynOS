{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        ratio = [
          1
          3
          4
        ];
        sort_by = "natural";
        sort_dir_first = true;
        sort_sensitive = false;
        show_hidden = true;
        show_symlink = true;
        linemode = "size";
        scrolloff = 5;
        mouse_events = [
          "click"
          "scroll"
          "drag"
        ];
      };

      preview = {
        max_width = 1200;
        max_height = 1200;
        image_filter = "lanczos3";
        image_quality = 90;
        ueberzug_scale = 1;
      };

      # first entry of the first `use` group is what Enter runs; O picks
      opener = {
        edit = [
          {
            run = "kitty --detach nvim %s";
            desc = "nvim";
            orphan = true;
            for = "unix";
          }
          {
            run = "code --new-window %s";
            desc = "VS Code";
            orphan = true;
            for = "unix";
          }
        ];

        pdf = [
          {
            run = "flatpak run ai.storyteller.pdfcraft %s";
            desc = "PdfCraft";
            orphan = true;
            for = "unix";
          }
          {
            run = "brave --new-window %s";
            desc = "Brave";
            orphan = true;
            for = "unix";
          }
          {
            run = "gimp %s";
            desc = "GIMP";
            orphan = true;
            for = "unix";
          }
        ];

        image = [
          {
            run = "loupe %s";
            desc = "Loupe";
            orphan = true;
            for = "unix";
          }
          {
            run = "gimp %s";
            desc = "GIMP";
            orphan = true;
            for = "unix";
          }
          {
            run = "brave --new-window %s";
            desc = "Brave";
            orphan = true;
            for = "unix";
          }
        ];

        play = [
          {
            run = "mpv %s";
            desc = "mpv";
            orphan = true;
            for = "unix";
          }
          {
            run = "brave --new-window %s";
            desc = "Brave";
            orphan = true;
            for = "unix";
          }
        ];

        archive = [
          {
            run = "file-roller %s";
            desc = "File Roller";
            orphan = true;
            for = "unix";
          }
        ];

        open = [
          {
            run = "xdg-open %s";
            desc = "System default";
            orphan = true;
            for = "linux";
          }
          {
            run = "code --new-window %s";
            desc = "VS Code";
            orphan = true;
            for = "unix";
          }
          {
            run = "kitty --detach nvim %s";
            desc = "nvim";
            orphan = true;
            for = "unix";
          }
        ];

        reveal = [
          {
            run = "xdg-open %d1";
            desc = "Reveal";
            orphan = true;
            for = "linux";
          }
        ];
      };

      # `open` leads so Enter follows mime.nix; O still reaches PdfCraft.
      open.prepend_rules = [
        {
          mime = "application/pdf";
          use = [
            "open"
            "pdf"
            "reveal"
          ];
        }
        {
          mime = "application/{epub+zip,postscript}";
          use = [
            "open"
            "pdf"
            "reveal"
          ];
        }
        {
          mime = "image/vnd.djvu";
          use = [
            "open"
            "pdf"
            "reveal"
          ];
        }
        {
          mime = "image/*";
          use = [
            "image"
            "open"
            "reveal"
          ];
        }
        {
          mime = "{audio,video}/*";
          use = [
            "play"
            "open"
            "reveal"
          ];
        }
        {
          mime = "text/*";
          use = [
            "edit"
            "open"
            "reveal"
          ];
        }
        {
          mime = "application/{json,ndjson,javascript,toml,xml,x-yaml,x-shellscript,x-desktop}";
          use = [
            "edit"
            "open"
            "reveal"
          ];
        }
        {
          mime = "inode/empty";
          use = [
            "edit"
            "open"
            "reveal"
          ];
        }
        {
          mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma}";
          use = [
            "extract"
            "archive"
            "reveal"
          ];
        }
      ];

      plugin.prepend_fetchers = [
        {
          url = "*";
          run = "git";
          group = "git";
        }
        {
          url = "*/";
          run = "git";
          group = "git";
        }
      ];
    };

    plugins = with pkgs.yaziPlugins; {
      inherit
        chmod
        compress
        full-border
        git
        jump-to-char
        lazygit
        relative-motions
        restore
        smart-enter
        starship
        ;
    };

    initLua = ''
      require("full-border"):setup({ type = ui.Border.ROUNDED })
      require("git"):setup()
      require("starship"):setup()
      require("relative-motions"):setup({ show_numbers = "relative_absolute", show_motion = true })
    '';

    keymap.mgr.prepend_keymap = [
      {
        on = "l";
        run = "plugin smart-enter";
        desc = "Enter directory or open file";
      }
      {
        on = "O";
        run = "open --interactive";
        desc = "Open with";
      }
      {
        on = "f";
        run = "plugin jump-to-char";
        desc = "Jump to char";
      }
      {
        on = [
          "c"
          "m"
        ];
        run = "plugin chmod";
        desc = "Chmod selection";
      }
      {
        on = [
          "z"
          "c"
        ];
        run = "plugin compress";
        desc = "Compress selection";
      }
      {
        on = "<C-g>";
        run = "plugin lazygit";
        desc = "lazygit";
      }
      {
        on = [
          "g"
          "u"
        ];
        run = "plugin restore";
        desc = "Restore from trash";
      }

      {
        on = "<Delete>";
        run = "remove";
        desc = "Move to trash";
      }
      {
        on = "y";
        run = [
          "yank"
          "escape --visual --select"
        ];
        desc = "Copy";
      }
      {
        on = "<C-n>";
        run = ''shell -- kitty --detach --directory "$PWD"'';
        desc = "Terminal here";
      }

      {
        on = [
          "g"
          "p"
        ];
        run = "cd ~/Projects";
        desc = "Projects";
      }
      {
        on = [
          "g"
          "o"
        ];
        run = "cd ~/Projects/OrynOS";
        desc = "OrynOS";
      }
      {
        on = [
          "g"
          "d"
        ];
        run = "cd ~/Downloads";
        desc = "Downloads";
      }
      {
        on = [
          "g"
          "D"
        ];
        run = "cd ~/Documents";
        desc = "Documents";
      }
      {
        on = [
          "g"
          "v"
        ];
        run = "cd ~/Videos";
        desc = "Videos";
      }
    ];

    extraPackages = with pkgs; [
      ffmpegthumbnailer
      poppler-utils
      imagemagick
      exiftool
      p7zip
      chafa
      fd
      ripgrep
      jq
      trash-cli
    ];
  };

  xdg.desktopEntries.yazi = {
    name = "Yazi";
    genericName = "File Manager";
    exec = "kitty -e yazi %f";
    terminal = false;
    icon = "system-file-manager";
    categories = [
      "Utility"
      "Core"
      "FileTools"
      "FileManager"
    ];
    mimeType = [ "inode/directory" ];
  };
}
