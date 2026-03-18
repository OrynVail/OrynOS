{ ... }: {
  wayland.windowManager.hyprland.settings = {
    bindr = [
      "SUPER, Super_L, exec, ambxst run launcher"
    ];

    bind = [
      "SUPER, D, exec, ambxst run dashboard"
      "SUPER, V, exec, ambxst run clipboard"
      "SUPER, period, exec, ambxst run emoji"
      "SUPER, N, exec, ambxst run notes"
      #"SUPER, T, exec, ambxst run tmux"
      "SUPER, comma, exec, ambxst run wallpapers"
      "SUPER, tab, exec, ambxst run overview"
      "SUPER, escape, exec, ambxst run powermenu"
      "SUPER SHIFT, C, exec, ambxst run config"
      "SUPER, L, exec, loginctl lock-session"
      "SUPER, S, exec, ambxst run tools"
      "SUPER SHIFT, S, exec, ambxst run screenshot"
      "SUPER SHIFT, R, exec, ambxst run screenrecord"
      "SUPER SHIFT, A, exec, ambxst run lens"
      "SUPER ALT, B, exec, ambxst reload"

      # --- Apps ---
      "SUPER, T, exec, kitty"
      "SUPER, E, exec, nautilus"
      "SUPER, C, exec, code"
      "SUPER, B, exec, brave"

      # --- Window Management ---
      "SUPER, Q, killactive"
      "SUPER, Delete, exit"
      "SUPER, W, togglefloating"
      "SUPER, G, togglegroup"
      "SHIFT, F11, fullscreen"
      "SUPER_SHIFT, F, pin"
      "SUPER, J, togglesplit"

      # --- Group Navigation ---
      "SUPER_CONTROL, H, changegroupactive, b"
      "SUPER_CONTROL, L, changegroupactive, f"

      # --- Change Focus ---
      "SUPER, Left, movefocus, l"
      "SUPER, Right, movefocus, r"
      "SUPER, Up, movefocus, u"
      "SUPER, Down, movefocus, d"

      # --- Move Active Window ---
      "SUPER_SHIFT_CONTROL, left, movewindow, l"
      "SUPER_SHIFT_CONTROL, right, movewindow, r"
      "SUPER_SHIFT_CONTROL, up, movewindow, u"
      "SUPER_SHIFT_CONTROL, down, movewindow, d"

      # --- Workspaces: Navigation ---
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"
      "SUPER, 0, workspace, 10"
      "SUPER, -, workspace, 11"

      "SUPER_CONTROL, Right, workspace, r+1"
      "SUPER_CONTROL, Left, workspace, r-1"
      "SUPER_CONTROL, Down, workspace, empty"
      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up, workspace, e-1"

      # --- Workspaces: Move Window ---
      "SUPER_SHIFT, 1, movetoworkspace, 1"
      "SUPER_SHIFT, 2, movetoworkspace, 2"
      "SUPER_SHIFT, 3, movetoworkspace, 3"
      "SUPER_SHIFT, 4, movetoworkspace, 4"
      "SUPER_SHIFT, 5, movetoworkspace, 5"
      "SUPER_SHIFT, 6, movetoworkspace, 6"
      "SUPER_SHIFT, 7, movetoworkspace, 7"
      "SUPER_SHIFT, 8, movetoworkspace, 8"
      "SUPER_SHIFT, 9, movetoworkspace, 9"
      "SUPER_SHIFT, 0, movetoworkspace, 10"

      "SUPER_CONTROL_ALT, Right, movetoworkspace, r+1"
      "SUPER_CONTROL_ALT, Left, movetoworkspace, r-1"

      # --- Workspaces: Move Window Silently ---
      "SUPER_ALT, 1, movetoworkspacesilent, 1"
      "SUPER_ALT, 2, movetoworkspacesilent, 2"
      "SUPER_ALT, 3, movetoworkspacesilent, 3"
      "SUPER_ALT, 4, movetoworkspacesilent, 4"
      "SUPER_ALT, 5, movetoworkspacesilent, 5"
      "SUPER_ALT, 6, movetoworkspacesilent, 6"
      "SUPER_ALT, 7, movetoworkspacesilent, 7"
      "SUPER_ALT, 8, movetoworkspacesilent, 8"
      "SUPER_ALT, 9, movetoworkspacesilent, 9"
      "SUPER_ALT, 0, movetoworkspacesilent, 10"
    ];

    # --- Holding Keys (Repeating) ---
    binde = [
      "SUPER_SHIFT, Right, resizeactive, 30 0"
      "SUPER_SHIFT, Left, resizeactive, -30 0"
      "SUPER_SHIFT, Up, resizeactive, 0 -30"
      "SUPER_SHIFT, Down, resizeactive, 0 30"
    ];

    # --- Mouse Binds ---
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
  };
}
