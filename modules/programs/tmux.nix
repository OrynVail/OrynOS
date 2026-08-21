{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    focusEvents = true;
    historyLimit = 50000;
    aggressiveResize = true;
    terminal = "tmux-256color";
    sensibleOnTop = false;

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      yank
      {
        plugin = extrakto;
        extraConfig = ''
          set -g @extrakto_key 'Tab'
          set -g @extrakto_clip_tool 'wl-copy'
        '';
      }
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-key t
          set -g @thumbs-command 'wl-copy {}'
        '';
      }
    ];

    extraConfig = ''
      setw -g pane-base-index 1
      set -g renumber-windows on
      set -g detach-on-destroy off
      set -g set-clipboard on
      set -g allow-passthrough on
      set -ga terminal-features "xterm-kitty:RGB"
      set -ga terminal-overrides ",xterm-kitty:Tc"

      set -g status-position bottom
      set -g status-justify left
      set -g status-left "#[bold] #S "
      set -g status-left-length 40
      set -g status-right " %H:%M "
      set -g status-right-length 20
      setw -g window-status-format " #I #W "
      setw -g window-status-current-format " #I #W#{?window_zoomed_flag, Z,} "
      setw -g window-status-separator ""

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      bind -n M-H resize-pane -L 5
      bind -n M-J resize-pane -D 3
      bind -n M-K resize-pane -U 3
      bind -n M-L resize-pane -R 5
      bind -n M-Enter resize-pane -Z

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind r source-file ~/.config/tmux/tmux.conf \; display " reloaded"

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-no-clear "wl-copy"

      bind g display-popup -E -w 90% -h 90% -d "#{pane_current_path}" lazygit
      bind e display-popup -E -w 90% -h 90% -d "#{pane_current_path}" yazi
      bind Space display-popup -E -w 50% -h 60% "sesh connect \"$(sesh list -i | fzf --prompt='sesh ' --height=100% --border=none)\""
    '';
  };

  home.packages = [ pkgs.sesh ];
}
