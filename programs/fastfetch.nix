{
  pkgs,
  userConfig,
  ...
}: {
  home.packages = with pkgs; [
    fastfetch
  ];

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = ../themes/OrynOS.png;
        type = "kitty";
        height = 12;
        padding = {
          top = 2;
          right = 2;
          left = 0;
        };
      };

      display = {
        separator = " ";
      };

      modules = [
        {
          key = "╭──────────────╮";
          type = "custom";
        }
        {
          key = "│ {#31} user       {#keys}│";
          type = "title";
          format = "{user-name}";
        }
        {
          key = "│ {#31}󰅐 uptime     {#keys}│";
          type = "uptime";
          format = "{days}d {hours}h {minutes}m";
        }
        {
          key = "│ {#31}󰍹 display    {#keys}│";
          type = "display";
          compactType = "original-with-refresh-rate";
        }
        {
          key = "│ {#31} distro     {#keys}│";
          type = "os";
          format = "{name} {version} {arch}";
        }
        {
          key = "│ {#31}󰌢 host       {#keys}│";
          type = "host";
          format = "{name} {version}";
        }
        {
          key = "│ {#31} kernel     {#keys}│";
          type = "kernel";
        }
        {
          key = "│ {#31}󱂬 wm         {#keys}│";
          type = "wm";
        }
        {
          key = "│ {#31}󰇄 desktop    {#keys}│";
          type = "de";
        }
        {
          key = "│ {#31} term       {#keys}│";
          type = "terminal";
        }
        {
          key = "│ {#31} shell      {#keys}│";
          type = "shell";
        }
        {
          key = "│ {#31}󰏖 apps       {#keys}│";
          type = "packages";
        }
        {
          key = "│ {#31}󰻠 cpu        {#keys}│";
          type = "cpu";
          format = "{name} │ {cores-physical}C/{cores-logical}T @ {freq-max}";
        }
        {
          key = "│ {#31}󰍛 gpu        {#keys}│";
          type = "gpu";
        }
        {
          key = "│ {#31} memory     {#keys}│";
          type = "memory";
        }
        {
          key = "│ {#31}󰋊 disk       {#keys}│";
          type = "disk";
          folders = "/";
        }
        {
          key = "│ {#31}󰩟 local ip   {#keys}│";
          type = "localip";
          format = "{ifname}: {ipv4}";
        }
        {
          key = "╰──────────────╯";
          type = "custom";
        }
      ];
    };
  };
}
