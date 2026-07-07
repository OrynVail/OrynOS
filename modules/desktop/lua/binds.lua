local mainMod = "SUPER"

-- Apps & Ambxst Launcher

hl.bind(mainMod .. " + Super_L", hl.dsp.exec_cmd("ambxst run launcher"), { release = true })

hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("ambxst run dashboard"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("ambxst run clipboard"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("ambxst run emoji"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("ambxst run notes"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("ambxst run wallpapers"))
hl.bind(mainMod .. " + tab", hl.dsp.exec_cmd("ambxst run overview"))
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("ambxst run powermenu"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("ambxst run config"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("ambxst run tools"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("ambxst run screenshot"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("ambxst run screenrecord"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("ambxst run lens"))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd("ambxst reload"))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("pear-desktop"))


-- Window Management

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Delete", hl.dsp.exit())
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind("SHIFT + F11", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.pin())


-- Group Navigation

hl.bind(mainMod .. " + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive b"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive f"))


-- Focus & Movement

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + CTRL + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + CTRL + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + CTRL + down", hl.dsp.window.move({ direction = "d" }))


-- binde

hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -30 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 30 }), { repeating = true })


-- Mouse

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- Special Workspace Rules & Navigation

hl.bind(mainMod .. " + minus", hl.dsp.focus({ workspace = "11" }))

hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + CTRL + ALT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + ALT + left", hl.dsp.window.move({ workspace = "r-1" }))


for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end
