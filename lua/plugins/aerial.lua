return {
--    "wellle/context.vim", -- shows the function name at the top as we scroll down the function code
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("aerial").setup({
	  backends = { "lsp", "treesitter" },

	  layout = {
		default_direction = "float",
		placement = "editor",
		min_width = 30,
		max_width = 60,
	  },
	  float = {
		relative = "editor", -- or "win"
	  },

	  manage_folds = true,

	  keymaps = {
		["<leader>"] = "actions.tree_toggle",  -- expand/collapse
		["<CR>"] = "actions.jump",      -- jump to symbol
		["q"] = "actions.close",
		["<Esc>"] = "actions.close",
	  },
	})
  end,
}