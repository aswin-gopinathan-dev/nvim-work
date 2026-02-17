return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require('neo-tree').setup({
			sources = {
				'filesystem',
				"git_status",
				"buffers",
			},

			open_on_setup = false,
			open_on_setup_file = false,
			enable_git_status = true,
			enable_diagnostics = true,

			default_component_configs = {
				git_status = {
					symbols = {
						-- Change type
						added     = "✚",
						modified  = "",
						deleted   = "✖",
						renamed   = "󰁕",
						untracked = "",
						ignored   = "",
						unstaged  = "󰄱",
						staged    = "",
						conflict  = "",
					},
				},
			},
			renderers = {
				file = {
					{ "git_status" },
					{ "indent" },
					{ "icon" },
					{ "name",      use_git_status_colors = true },
				},
				directory = {
					{ "indent" },
					{ "icon" },
					{ "name",      use_git_status_colors = true },
					{ "git_status" },
				},
			},
			filesystem = {
				header = {
					-- Set this to true to display only the project name
					show_root_name = true,
				},
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						".DS_Store",
						--".git",
						".gitignore",
						"README.md",
						"build",
						".cache"
					},
					show_hidden_count = false,
					never_show = {},
				},
			},
			window = {
				position = "left",
				width = 35,
				auto_expand_width = false,
				mappings = {
					-- Disable the default delete operation
					["d"] = "none",
					-- Disable the default rename operation
					["r"] = "none",
					-- Optional: Disable other destructive or modification operations
					["a"] = "none", -- add file/directory
					["c"] = "none", -- copy
					["m"] = "none", -- move
					["y"] = "none", -- copy to clipboard

					["u"] = "navigate_up",
				},
			},
		})

		local function neotree_is_open()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].filetype == "neo-tree" then
					return true
				end
			end
			return false
		end

		local function open_neotree()
			if not neotree_is_open() then
				pcall(vim.cmd, "Neotree show left")

				vim.schedule(function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].filetype ~= "neo-tree" then
							vim.api.nvim_set_current_win(win)
							break
						end
					end
				end)
			end
		end

		-- When starting normally (no session restore), open after UI is ready
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.schedule(open_neotree)
			end,
		})

		-- When a session is restored, open AFTER the restore has finished
		vim.api.nvim_create_autocmd("SessionLoadPost", {
			callback = function()
				vim.schedule(open_neotree)
			end,
		})
	end,
}
