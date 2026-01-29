return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")
	local actions = fzf.actions 

    fzf.setup({
      -- 🔹 UI
      winopts = {
        height = 0.95,
        width = 0.75,
        row = 0.20,
        col = 0.50,
        border = "rounded",
        preview = {
          layout = "vertical",
          vertical = "down:60%",
          horizontal = "right:60%",
          border = "border",
          wrap = "nowrap",
        },
      },

      -- 🔹 Files
      files = {
        prompt = "Files❯ ",
        git_icons = true,
        file_icons = true,
        color_icons = true,
        cwd_prompt = false,
		
		cmd = "fd",
		
		fd_opts = [[
		  --type f
		  --hidden
		  --follow
		  --exclude .git
		  --exclude build
		  --exclude out
		  --exclude venv
		  --exclude .venv
		  --exclude site-packages
		]],
      },

      -- 🔹 Grep
       grep = {
		cmd = "rg",

		-- IMPORTANT: vimgrep-style output so fzf-lua can parse file/line/col
		rg_opts = [[
				  --vimgrep
				  --smart-case
				  --hidden
				  --color=never
				  --no-heading
				  --fixed-strings
				  --glob !.git/**
				  --glob !build/**
				  --glob !out/**
				  --glob !venv/**
				  --glob !.venv/**
				  --glob !**/site-packages/**
				  --glob !**/sagacity/Lib/**
				  --glob !**/[Ll]ogs/**
				]],


		-- keep messages off if you like
		silent = true,

		-- you can turn previewer back on once things work; for now keep it simple
		previewer = "builtin",

		-- make sure Enter edits the file in the current window
		actions = {
		  ["default"] = actions.file_edit,     -- <CR>
		  ["ctrl-s"]  = actions.file_split,    -- <C-s>
		  ["ctrl-v"]  = actions.file_vsplit,   -- <C-v>
		  ["ctrl-t"]  = actions.file_tabedit,  -- <C-t>

		},
		
		fzf_opts = {
		  ["--bind"] = table.concat({
			"shift-down:preview-down",
			"shift-up:preview-up",
			"ctrl-d:preview-half-page-down",
			"ctrl-u:preview-half-page-up",
		  }, ","),
		},
	  },

      -- 🔹 LSP
      lsp = {
        prompt_postfix = "❯ ",
        symbols = {
          symbol_hl = "TroubleText",
          symbol_fmt = function(s)
            return s:lower()
          end,
        },
      },

      -- 🔹 Git
      git = {
        status = {
          prompt = "GitStatus❯ ",
        },
      },

    })
  end,
}
