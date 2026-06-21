-- Curves

hl.curve("snappy", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })    
hl.curve("smoothOut", { type = "bezier", points = { {0.3, 0}, {0.1, 1.0} } })      
hl.curve("linear", { type = "bezier", points = { {1, 1}, {1, 1} } })               
hl.curve("overshot", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })   


-- Animations
-- Syntax: leaf, enabled, speed (1 = fastest), curve, [style]

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "snappy", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "snappy" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })

hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "linear", style = "loop" })

hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smoothOut" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slidefade 20%" })