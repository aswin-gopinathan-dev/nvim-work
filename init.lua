
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then   -- if lazy.nvim doesnt exit in nvim-data folder, clone it from github
  vim.fn.system({
    "git", 
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", 
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) -- add lazy nvim clone folder to runtime path

vim.opt.errorformat:prepend({
  [[%f(%l\,%c): %trror: %m]],
  [[%f(%l\,%c): %tarning: %m]],
  [[%f(%l\,%c): %tnote: %m]],
  -- fallback (covers "error:" / "warning:" / etc. generically)
  [[%f(%l\,%c): %t%*[^:]: %m]],
})

vim.opt.fillchars:append({ eob = " " })

vim.opt.termguicolors = true

require("vim-options")
require("lazy").setup("plugins")
require("vim-keymaps-general")
--require("vim-keymaps-build")
require("vim-keymaps-debug")

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h9"
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_scroll_animation_length = 0
end

vim.opt.clipboard = "unnamedplus"

vim.env.RIPGREP_CONFIG_PATH = nil
vim.env.RG_DEFAULT_COMMAND = nil
vim.opt.shadafile = vim.fn.stdpath("data") .. "/shada/main.shada"
