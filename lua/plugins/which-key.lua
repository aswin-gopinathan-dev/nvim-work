return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 2000
    end,
    opts = {
        delay = 1000,
    },
	
	config = function()
	  require("which-key").setup({
	  plugins = {
		presets = {
		  operators = false,   -- optional
		  motions = false,     -- optional
		  text_objects = false,-- optional
		  windows = false,     -- optional
		  nav = false,         -- optional
		  z = false,           -- optional
		  g = false,           -- optional
		},
	  },
	  layout = {
		spacing = 12, -- spacing between columns
	  },
	  icons = {
	    group = "",
	  },
	  preset="modern",
	  expand=0,
	  sort={"alphanum"},
	  show_help = false,         -- disables the inline help
	  --ignore_missing = true,     -- skip mappings that don't have desc
	  disable = {
		filetypes = {},
		buftypes = {},
	  },
	  win = {
		border = "rounded",
		padding = { 1, 2 },
		title = true,
		title_pos = "center",

		width = {
		  min = 40,
		  max = math.huge,
		},
	  },
	  
	  
	  triggers = {},
	  
	  -- 👇 This is the key one to suppress the "old spec" warning:
	  disable_warn = true,
	  
	})
	
	end,
}


