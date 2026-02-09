return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    local neoscroll = require("neoscroll")

    neoscroll.setup({
      mappings = {},
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = true,
      cursor_scrolls_alone = true,
      easing_function = "linear",
    })

    local keymap = {
      ["<leader><Up>"] = function() neoscroll.ctrl_u({ duration = 1500, easing = "linear" }) end,
      ["<leader><Down>"] = function() neoscroll.ctrl_d({ duration = 1500, easing = "linear" }) end,

      ["<leader><PageUp>"] = function() neoscroll.ctrl_b({ duration = 350, easing = "quadratic" }) end,
      ["<leader><PageDown>"] = function() neoscroll.ctrl_f({ duration = 350, easing = "quadratic" }) end,
    }

    local modes = { "n", "v", "x" }
    for lhs, rhs in pairs(keymap) do
      vim.keymap.set(modes, lhs, rhs, { silent = true, desc = "Neoscroll" })
    end
  end,
}
