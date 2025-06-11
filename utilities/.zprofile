# --- auto-start Hyprland on the console -----------------------------
if [[ -z $WAYLAND_DISPLAY && -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
  # make sure Hyprland is installed and not already running
  if command -v Hyprland >/dev/null && ! pgrep -x Hyprland >/dev/null; then
    exec dbus-run-session Hyprland
  fi
fi
# --------------------------------------------------------------------
