return {
  "linux-cultist/venv-selector.nvim",
  ft = { "python" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "stevearc/dressing.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
	  "<leader>tv",
	  function()
	    local old_cwd = vim.fn.getcwd()
		vim.cmd("cd C:/Repos")
		vim.cmd("VenvSelect")
		vim.cmd("cd " .. vim.fn.fnameescape(old_cwd))
	  end,
	  desc = "cd C:/Repos → select venv",
	},
  },
  opts = {
    options = {
      fd_binary_name = [[C:\ProgramData\chocolatey\bin\fd.exe]],
      notify_user_on_venv_activation = false,
      auto_refresh_lsp = true,
      debug = true, -- enables :VenvSelectLog
    },
    -- start with NO custom searches until it works
    -- (plugin default searches should work once fd_binary_name is valid)
  },
}
