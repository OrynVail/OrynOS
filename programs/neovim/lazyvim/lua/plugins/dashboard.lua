-- lua/plugins/dashboard.lua

return {
	"snacks.nvim",
	opts = {
		dashboard = {
			preset = {
				-- Using a multi-line string for the header
				header = [[
  ▄▄▄  ▄   ▄ ▄ ▄▄▄▄  
 █   █ █   █ ▄ █ █ █ 
 ▀▄▄▄▀  ▀▄▀  █ █   █ 
              █         

  — Enter the Void —  
]],
				-- LazyVim will use the default keymaps unless you override them here
				-- keys = { ... }
			},
		},
	},
}
