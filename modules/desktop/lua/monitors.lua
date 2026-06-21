local giga_monitor = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G24F 2 22410B002844"

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.monitor({
    output = giga_monitor,
    mode = "1920x1080@144.00",
    position = "0x0",
    scale = 1,
})

-- binding
for i = 1, 10 do
    local is_default = (i == 1) 
    
    hl.workspace_rule({ 
        workspace = tostring(i), 
        persistent = true, 
        monitor = giga_monitor, 
        default = is_default 
    })
end