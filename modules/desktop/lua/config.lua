-- Environment Variables

hl.env("AQ_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("EGL_PLATFORM", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")
hl.env("NIXPKGS_ALLOW_UNFREE", "1")
hl.env("WLR_RENDERER", "vulkan")


-- Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("ambxst")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("polkit-agent-helper-1")
end)


-- Config

hl.config({
    input = {
        kb_layout = "us",
        kb_options = "grp:win_space_toggle",
        repeat_delay = 250,
        repeat_rate = 40,
        sensitivity = 0,
        accel_profile = "flat",
        follow_mouse = 1,
        mouse_refocus = false,
        touchpad = {
            natural_scroll = true,
        }
    },

    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        col = {
	        active_border = {
	        colors = { "rgba(c79595ff)", "rgba(c795aeff)" },
		angle = 45,
		},
        },
        layout = "dwindle",
        resize_on_border = true,
    },

    decoration = {
        rounding = 16,
        active_opacity = 0.9,
        inactive_opacity = 0.8,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
        },
        shadow = {
            enabled = false,
        }
    },

    render = {
		direct_scanout = 0, -- 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
	},

    ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},

    misc = {
        disable_hyprland_logo = true,
        mouse_move_focuses_monitor = true,
        swallow_regex = "^(Alacritty|kitty)$",
        enable_swallow = true,
        vrr = 1, -- (0 = off, 1 = on, 2 = fullscreen only, 3 = fullscreen games / media)
	},

    dwindle = {
		preserve_split = true,
	},
})
