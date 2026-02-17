local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then -- if lazy.nvim doesnt exit in nvim-data folder, clone it from github
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
vim.g.restoring_session = false

require("vim-options")
require("lazy").setup("plugins")
require("vim-keymaps-general")
require("vim-keymaps-debug")
require("which-key-entries")


vim.opt.clipboard = "unnamedplus"

vim.env.RIPGREP_CONFIG_PATH = nil
vim.env.RG_DEFAULT_COMMAND = nil

local shada_dir = vim.fn.stdpath("data") .. "\\shada"
local shada_file = shada_dir .. "\\main.shada"

if vim.fn.isdirectory(shada_dir) == 1 then
  vim.fn.system('cmd /c del /q "' .. shada_dir .. '\\*.tmp.*"')
end

vim.opt.shada = "!,'100,<50,s10,h"
vim.opt.shadafile = shada_file

vim.opt.guicursor =
    "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50," ..
    "a:blinkwait700-blinkoff400-blinkon250"

vim.opt.sessionoptions:remove("terminal")

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    -- Reset terminal attributes
    io.write("\27[0m")     -- reset colors
    io.write("\27[?25h")   -- ensure cursor visible
    io.write("\27[?1049l") -- ensure alt screen disabled
    io.flush()
  end,
})



_G.MyConfig = {
  case_sensitive = false,
  match_whole_word = false,
  skip_folders = { ".git", "build", "env", "venv", "logs", "sagacity_env",
    "site-packages", "__pycache__", "ffmpeg", "extern", "pybind11" },
  file_extensions = {},
}
