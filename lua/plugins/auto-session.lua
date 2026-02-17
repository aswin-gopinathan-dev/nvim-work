return {
	"rmagatti/auto-session",
	lazy = true,
	enabled = true,
	event = "VimEnter",
	config = function()
		-- Make sure sessions never store/restore terminal buffers
		vim.opt.sessionoptions:remove("terminal")

		require("auto-session").setup({
			enabled = true,
			auto_save = true,
			auto_restore = true,
			auto_create = true,

			root_dir = vim.fn.stdpath("data") .. "/sessions/",

			bypass_save_filetypes = { "alpha", "dashboard" },

			bypass_save_filetypes = {
				"alpha",
				"dashboard",
				"toggleterm",
				"terminal",
			},

			close_filetypes_on_save = {
				"checkhealth",
				"neo-tree",
				"neo-tree-popup",
				"toggleterm",
				"terminal",
			},

			close_unsupported_windows = true,
			
			pre_restore_cmds = {
				function()
					vim.g.restoring_session = true
				end,
			},

			post_restore_cmds = {
				function()
					vim.g._auto_session_restored = true
					vim.schedule(function()
						vim.g.restoring_session = false
						-- Manually trigger for the one buffer you are actually looking at
						vim.cmd("edit!")
	  
						-- reopen neo-tree safely after windows are restored
						--[[pcall(function()
							require("neo-tree.command").execute({
								action = "show",
								source = "filesystem",
								position = "left",
								focus = false,
							})
							vim.defer_fn(function()
								pcall(vim.cmd, "wincmd p")
							end, 300)
						end)  ]]

						-- fix filetype/syntax/treesitter not attaching after restore:
						vim.cmd("silent! filetype plugin indent on")
						vim.cmd("silent! syntax on")

						--[[
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_loaded(buf)
								and vim.api.nvim_buf_get_name(buf) ~= ""
								and vim.bo[buf].buftype == ""
							then
								pcall(vim.api.nvim_exec_autocmds, "BufReadPost", { buffer = buf })
								pcall(vim.api.nvim_exec_autocmds, "FileType", { buffer = buf })
							end
						end ]]
					end)
				end,
			},

		})
	end,
}
