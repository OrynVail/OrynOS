hl.window_rule({
    match = { class = "^([Ff]irefox|firefox-beta|[Bb]rave-browser)$" },
    opacity = "0.90 0.90 1.0"
})

hl.window_rule({
    match = { class = "^(kitty|[Aa]lacritty)$" },
    opacity = "0.90 0.90 1.0"
})

hl.window_rule({
    match = { class = "^(code-oss|Code|VSCodium|codium-url-handler)$" },
    opacity = "0.80 0.80 1.0"
})

hl.window_rule({
    match = { class = "^(org.kde.dolphin|org.gnome.Nautilus|kvantummanager)$" },
    opacity = "0.80 0.80 1.0"
})

hl.window_rule({
    match = { class = "^(nwg-look|qt5ct|qt6ct|yad)$" },
    opacity = "0.80 0.80 1.0",
    float = true
})

hl.window_rule({
    match = { class = "^(org.pulseaudio.pavucontrol|pavucontrol|blueman-manager|.blueman-manager-wrapped|nm-applet|nm-connection-editor)$" },
    opacity = "0.80 0.70 1.0",
    float = true
})

hl.window_rule({
    match = { class = "^(Spotify)$" },
    opacity = "0.70 0.70 1.0"
})

hl.window_rule({
    match = { class = "^([Dd]iscord|[Vv]esktop)$" },
    opacity = "0.80 0.80 1.0"
})

hl.window_rule({
    match = { class = "^(Signal|com.github.rafostar.Clapper|app.drey.Warp|net.davidotek.pupgui2|eog|io.github.alainm23.planify|io.missioncenter.MissionCenter)$" },
    float = true
})

hl.window_rule({
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin = true,
    move = "73% 72%",
    size = "25% 25%",
    no_initial_focus = true
})

hl.window_rule({
    match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
    opacity = "0.80 0.70 1.0",
    float = true
})