local giga_desc = "GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"
local giga = "desc:" .. giga_desc
local internal = "eDP-1"
local workspaces = 9

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.monitor({
    output = giga,
    mode = "1920x1080@144.00",
    position = "0x0",
    scale = 1,
})

local function docked()
    for _, m in ipairs(hl.get_monitors()) do
        if m.description:find(giga_desc, 1, true) then
            return true
        end
    end
    return false
end

local function apply()
    local on_giga = docked()

    if not on_giga then
        hl.monitor({
            output = internal,
            mode = "preferred",
            position = "auto",
            scale = 1,
            disabled = false,
        })
    end

    for i = 1, workspaces do
        hl.workspace_rule({
            workspace = tostring(i),
            persistent = true,
            default = i == 1,
            monitor = on_giga and giga or internal,
        })
    end

    if on_giga then
        hl.monitor({ output = internal, disabled = true })
    end
end

local generation = 0

local function schedule()
    generation = generation + 1
    local mine = generation

    hl.timer(function()
        if mine == generation then
            apply()
        end
    end, { timeout = 250, type = "oneshot" })
end

hl.on("hyprland.start", apply)
hl.on("monitor.added", schedule)
hl.on("monitor.removed", apply)

apply()
