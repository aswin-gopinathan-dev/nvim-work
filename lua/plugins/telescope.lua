return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
	cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-pack/nvim-spectre' },
    config = function()
      local telescope = require("telescope")
      local sorters   = require("telescope.sorters")
      local themes    = require("telescope.themes")

      telescope.setup({
        extensions = {
          ["ui-select"] = themes.get_dropdown({}),
        },

        defaults = {
			vimgrep_arguments = {
			  "rg",
			  "--color=never",
			  "--no-heading",
			  "--with-filename",
			  "--line-number",
			  "--column",
			  "--smart-case",
			  "--fixed-strings",

			  -- 🚫 EXACT folder exclusions (WORKS)
			  "--glob", "!**/env/**",
			  "--glob", "!**/venv/**",
			  "--glob", "!**/.venv/**",
			  "--glob", "!**/sagacity_env/**",
			  "--glob", "!**/site-packages/**",
			  "--glob", "!**/build/**",

			  -- 🧹 sanity exclusions
			  "--glob", "!**/__pycache__/**",
			  "--glob", "!**/.git/**",
			},
			
          layout_strategy = "vertical",
          layout_config = {
            horizontal = {
              width          = 0.9,
              height         = 0.95,
              preview_height = 0.5,
              preview_cutoff = 1,
            },
            vertical = {
              width          = 0.9,
              height         = 0.95,
              preview_height = 0.5,
              preview_cutoff = 1,
            },
            center = {
              width  = 0.9,
              height = 0.95,
            },
          },

          -- Selection starts at the top of the list
          sorting_strategy = "ascending",

          -- 🔑 This is what actually kills char-by-char fuzzy file matching
          -- and turns `find_files` into plain substring matching.
          file_sorter = sorters.get_substr_matcher,

          cache_picker = {
            num_pickers = 10, -- keep last 10 pickers
          },
        },
	  
	  
        pickers = {
          -- You can add more picker-specific tweaks here if needed
          find_files = {
            -- no need for `fuzzy = false` once file_sorter is substring-based
            -- you can still add options like:
            -- hidden = true,
			hidden = true,
			  no_ignore = false,
			  file_ignore_patterns = {
				".git\\",
				"build\\",
				"env\\",
				"logs\\",
				"sagacity_env\\",
				"site-packages\\",
				"__pycache__\\",
			  },
          },

          live_grep = {
            additional_args = function()
            return {
                "--fixed-strings",   -- literal match, no regex
                "--smart-case",      -- optional but nice

                -- 🔽 skip exact env / venv folders
                "--glob", "!**/env/**",
                "--glob", "!**/venv/**",
                "--glob", "!**/logs/**",
				"--glob", "!**/sagacity_env/**",
            }
        end,
          },
        },
      })

      telescope.load_extension("ui-select")
    end,
  },
}
