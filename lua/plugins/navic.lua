return {
  "SmiteshP/nvim-navic",
  dependencies = "neovim/nvim-lspconfig",
  config = function()
    require("nvim-navic").setup {
      highlight = false,
      separator = " 󰛂 ",
      depth_limit = 5,
	  lsp = {
		-- Set to true to auto-attach to all servers (with symbolProvider)
		auto_attach = true,
		-- Priority list for multiple servers
		preference = { "pyright", "clangd" },
	  },
    }
  end,
}