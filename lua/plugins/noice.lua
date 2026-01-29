return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "  " },
          search_up = { kind = "search", pattern = "^%?", icon = "  " },
          filter = { pattern = "^:%s*!", icon = " ", lang = "bash" },
		  input = { icon = "󰥻 ", lang = "text" },
        },
      },
	  notify = {
        enabled = false,
      },
	  input = {
		  enabled = true,
		  view = "cmdline_popup", -- or "popup"
		},

      -- Force our popup + title
      views = {
        cmdline_popup = {
          position = { row = "50%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = {
            style = "rounded",
            padding = { 0, 1 },
            text = {
              top = " Command ",
              top_align = "center",
            },
          },
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },	      
        },
      },

      popupmenu = { enabled = true, backend = "nui" },

      presets = {
        bottom_search = true,
        command_palette = false, -- <-- THIS must be false
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    })
  end,
}
