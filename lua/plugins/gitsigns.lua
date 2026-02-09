return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      -- ── SIGNS ───────────────────────────────────────────────
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "▔" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▔" },
        untracked    = { text = "┆" },
      },

      signcolumn = true,      -- show signs in sign column
      numhl      = false,     -- line number highlight
      linehl     = false,     -- whole line highlight
      word_diff  = false,     -- inline diff (can be noisy)

      watch_gitdir = {
        follow_files = true,
      },

      auto_attach = true,

      -- ── BLAME ───────────────────────────────────────────────
      current_line_blame = false,  -- toggle via keymap
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
        ignore_whitespace = false,
      },
      current_line_blame_formatter =
        "<author>, <author_time:%Y-%m-%d> • <summary>",

      -- ── PREVIEW ─────────────────────────────────────────────
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 1,
        col = 1,
      },

      -- ── PERFORMANCE ─────────────────────────────────────────
      update_debounce = 100,
      max_file_length = 40000,
    })
  end,
}
