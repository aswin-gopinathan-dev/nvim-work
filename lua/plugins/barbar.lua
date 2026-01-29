return
  {'romgrk/barbar.nvim',
    enabled = false,
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
	  'stevearc/resession.nvim',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      animation = false,
	  -- preset = 'default',
	  icons = {
		buffer_index = true,
		separator = { left = "", right = "" },
	  },
	  padding = 0,
	  minimum_padding = 0,
	  
	  sidebar_filetypes = {
		["neo-tree"] = {
		  event = "BufWipeout",
		  text = "File Explorer",
		  align = "left",
		},
	  },
    },
	
	
  }