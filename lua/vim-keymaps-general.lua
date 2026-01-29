local keymap = vim.keymap
local wk = require("which-key")


-- <leader>f	--> Begin Find Functionalities
-- ===========================================

vim.keymap.set("n", "<leader>fg", function()
  require("grug-far").open()
end, { desc = "Search & Replace (Grug FAR popup)" })


local builtin = require("telescope.builtin")
keymap.set("n", "<leader>ff", builtin.find_files, {desc="Find Files"})

keymap.set("n", "<leader>fR", vim.lsp.buf.rename, {desc="Replace String"})
keymap.set("n", "<leader>ft", function()
  local ft = vim.bo.filetype

  if ft == "qml" then
    vim.cmd("silent !qmlformat -i %")
    vim.cmd("edit")
  else
    vim.lsp.buf.format({ async = true })
  end
end, {desc="Format File"})

vim.keymap.set("n", "<leader>fs", function()
  local word = vim.fn.expand("<cword>")

  local tb = require("telescope.builtin")
  if word ~= nil and word ~= "" then
    tb.grep_string({
      search = word,
      use_regex = false, -- important
      additional_args = function()
        return { "--fixed-strings" } -- literal substring match
      end,
    })
  else
    tb.live_grep({
      additional_args = function()
        return { "--fixed-strings" }
      end,
    })
  end
end, { desc = "Grep word under cursor (literal) or live grep (literal)" })


vim.keymap.set('n', '<leader>fr', function() require('telescope.builtin').lsp_references() end, { noremap = true, silent = true })

vim.keymap.set("v", "<leader>fs", function()  -- Search selected text --> Press viw in normal to highlight the word under cursor
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  local lines = vim.fn.getline(ls, le)
  if #lines == 0 then return end
  lines[#lines] = string.sub(lines[#lines], 1, ce)
  lines[1] = string.sub(lines[1], cs)
  local text = table.concat(lines, "\n")

  require("telescope.builtin").grep_string({
    default_text = text,
  })
end, { desc = "Live Grep Visual Selection" })
keymap.set('n', '<leader>fx', ':nohlsearch<CR>')
vim.keymap.set("n", "<leader>fd", function()
  local aerial = require("aerial")
  aerial.open({ direction = "float", focus = true })
end, { desc = "List classes/methods" })
-- =========================================
-- <leader>f	--> End Find Functionalities


--vim.o.winbar = "zz  %{%v:lua.vim.fn.expand('%F')%} xx  %{%v:lua.require'nvim-navic'.get_location()%} yy"


-- <leader>b	--> Begin Tab Functionalities
-- ===========================================
keymap.set("n", "<leader>b[", "<Cmd>BufferLineCyclePrev<CR>")
keymap.set("n", "<leader>b]", "<Cmd>BufferLineCycleNext<CR>")
keymap.set("n", "<leader>b,", "<Cmd>BufferLineGoToBuffer 1<CR>")
keymap.set("n", "<leader>b.", "<Cmd>BufferLineGoToBuffer -1<CR>")
keymap.set("n", "<leader>bx", "<Cmd>BufferLinePickClose<CR>")
keymap.set("n", "<leader>bX", "<Cmd>BufferLineCloseOthers<CR>")
keymap.set("n", '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })
keymap.set("n", "<leader><tab>", "<cmd>b#<CR>", { noremap = true, silent = true })
keymap.set("n", '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true })
keymap.set("i", '<leader><S-Tab>', '<Esc><Cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>bo", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local dir = vim.fn.fnamemodify(file, ":p:h")
  dir = dir:gsub("/", "\\")
  if dir:match("^[A-Za-z]:$") then
    dir = dir .. "\\"
  end

  if vim.loop.fs_stat(dir) == nil then
    vim.notify("Folder not found: " .. dir, vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({ "cmd.exe", "/c", "start", "", "explorer.exe", dir }, { detach = true })
end, { desc = "Open buffer folder in Explorer" })


for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    vim.cmd("BufferLineGoToBuffer " .. i)
  end, { silent = true, desc = nil })
end

keymap.set("n", "<leader>0", "<Cmd>b#<CR>", { silent = true, desc = nil })

-- ========================================
-- <leader>b	--> End Tab Functionalities



-- <leader>u	--> Begin Utilties Functionalities
-- ===========================================
keymap.set("n", "<leader>ub", "<cmd>lua require('marks.bookmark').toggle()<CR>")
keymap.set("n", "<leader>u]", "<cmd>lua require('marks.move').next()<CR>")
keymap.set("n", "<leader>u[", "<cmd>lua require('marks.move').prev()<CR>")
keymap.set("n", "<leader>ua", "<cmd>MarksListBuf<CR>")
--keymap.set("n", "<leader>ux", bm.clear)

vim.keymap.set("n", "<leader>ub", "<Plug>(Marks-toggle-bookmark0)", {silent = true})
vim.keymap.set("n", "<leader>u]", "<Plug>(Marks-next-bookmark0)", {silent = true})
vim.keymap.set("n", "<leader>u[", "<Plug>(Marks-prev-bookmark0)", {silent = true})
vim.keymap.set("n", "<leader>ul", "<cmd>BookmarksListAll<CR>")
-- <leader>u	--> End Utilties Functionalities



-- <leader>w	--> Begin Window Functionalities
-- =============================================
keymap.set("n", "<leader>wh", "<C-w>v")
keymap.set("n", "<leader>wv", "<C-w>s")
keymap.set("n", "<leader>we", "<C-w>=")
keymap.set("n", "<leader>wx", "<cmd>close<CR>")
keymap.set('n', '<leader>w]', function()
  local start_win = vim.api.nvim_get_current_win()
  local function is_neotree(win)
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    return bufname:match("neo%-tree")
  end

  vim.cmd("wincmd w")
  local curr_win = vim.api.nvim_get_current_win()

  while curr_win ~= start_win and is_neotree(curr_win) do
    vim.cmd("wincmd w")
    curr_win = vim.api.nvim_get_current_win()
  end
end, { desc = "Cycle windows" })

keymap.set({"n", "t"}, '<leader>wr<Down>', ':resize +2<CR>')
keymap.set({"n", "t"}, '<leader>wr<Up>', ':resize -2<CR>')
keymap.set({"n", "t"}, '<leader>wr<Left>', ':vertical resize +2<CR>')
keymap.set({"n", "t"}, '<leader>wr<Right>', ':vertical resize -2<CR>')
-- ===========================================
-- <leader>w	--> End Window Functionalities



-- <leader>g	--> Begin Navigation Functionalities
-- =================================================
keymap.set("n", "<leader>g[", "<C-o>") -- go to previous cursor pos
keymap.set("n", "<leader>g]", "<C-i>") -- go to next cursor pos
keymap.set("n", "<leader>[", "<C-o>")  -- go to previous cursor pos
keymap.set("n", "<leader>]", "<C-i>")  -- go to next cursor pos
keymap.set("n", "<leader>ge", "$")     -- go to end of current line
keymap.set("n", "<leader>gs", "^")     -- go to start of current line
keymap.set("n", "<leader>gS", "gg^")   -- go to start of current file
keymap.set("n", "<leader>gE", "G$")    -- go to end of current line
-- =================================================
-- <leader>g	--> End Navigation Functionalities



-- <leader>t	--> Begin Terminal Functionalities
-- ===============================================
local function close_quickfix()
  local wininfo = vim.fn.getwininfo()
  for _, win in ipairs(wininfo) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
    end
  end
end

vim.keymap.set("n", "<leader>tf", function()
  close_quickfix()
  local cwd = vim.fn.getcwd()
  vim.cmd(string.format("ToggleTerm dir=%s direction=float", cwd))
end, { desc = "Open Floating Terminal" })

vim.keymap.set("n", "<leader>tt", function()
  close_quickfix()
  local cwd = vim.fn.getcwd()
  vim.cmd(string.format("ToggleTerm dir=%s direction=horizontal", cwd))
end, { desc = "Open Horizontal Terminal" })

keymap.set("t", "<leader>tt", "<Cmd>ToggleTerm<CR>")

-- Preview the SVG PathSvg { path: "..." } under cursor
-- Usage: put cursor anywhere inside the quoted path string, press the shortcut
local function preview_svg()
  vim.cmd([[normal! "vyi"]])
  local path = vim.fn.getreg("v")

  if not path or path == "" then
    vim.notify('No path yanked. Put cursor inside the "path" string first.', vim.log.levels.WARN)
    return
  end

  local viewBox = "0 0 100 100"
  local width, height = 360, 360
  local fill = "#000000"

  local svg = string.format([[
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="%s" width="%d" height="%d">
				<path d="%s" fill="%s"/>
				</svg>
			]], viewBox, width, height, path, fill)

  local tempdir = vim.env.TEMP or vim.env.TMP or "."
  local outfile = tempdir .. "\\qml_path_preview.svg"

  local f, err = io.open(outfile, "w")
  if not f then
    vim.notify("Failed to write SVG: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  f:write(svg)
  f:close()

  local cmd = string.format([[cmd.exe /c start "" "%s"]], outfile)
  vim.fn.jobstart(cmd, { detach = true })
end

vim.keymap.set("n", "<leader>ts", function()
  preview_svg()
end, { desc = 'Preview SVG' })

vim.keymap.set("n", "<F8>", function()
  preview_svg()
end, { desc = 'Preview SVG' })


local function launch_app(pgm)
  local Terminal = require("toggleterm.terminal").Terminal

  -- create (or reuse) a normal shell
  if not _G.entrypoint_term then
    _G.entrypoint_term = Terminal:new({
      direction = "horizontal",
      close_on_exit = false,
      hidden = false,
    })
  end

  if not _G.entrypoint_term:is_open() then
	_G.entrypoint_term:open()
  end
  
  -- send command AFTER terminal is ready
  vim.defer_fn(function()
    _G.entrypoint_term:send("cls", true)
    _G.entrypoint_term:send(pgm, true)
  end, 50)
end

vim.keymap.set("n", "<leader>tr", function()
  local src_buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(src_buf) -- absolute path or "" for non-file buffers
  local ext  = vim.fn.fnamemodify(file, ":e")
  
  local cmd
  if ext == "qml" then
    cmd = string.format('qml.exe "%s"', file)
  else
    cmd = "python .\\entrypoint.py"
  end
  
  launch_app(cmd)
end, { desc = "Run Application" })

vim.keymap.set({ "n", "i" }, "<F7>", function()
  vim.cmd("write")
  vim.cmd("stopinsert")
  launch_app("python .\\entrypoint.py")
end)

vim.keymap.set("n", "<leader>xx", function()
  vim.cmd("wshada!")
  local shada = vim.fn.stdpath("data") .. "/shada/main.shada"
  vim.fn.delete(shada)
end)

vim.keymap.set({ "t" }, "<Esc><Esc>", function()
  local ok, term = pcall(require, "toggleterm.terminal")
  if not ok then return end

  -- Close all open toggleterm terminals
  for _, t in pairs(term.get_all()) do
    if t:is_open() then
      t:close()
    end
  end
end)
-- <leader>tv mapping is in py-venv.lua

-- =============================================
-- <leader>t	--> End Terminal Functionalities



-- <leader>e	--> Begin Explorer Functionalities
-- ===============================================
keymap.set("n", "<leader>ee", ":Neotree toggle<CR>")
keymap.set("n", "<leader>ef", ":Neotree focus<CR>")

local function open_explorer(path)
  if path == nil or path == "" then
    path = vim.fn.getcwd()
  end
  path = path:gsub("/", "\\")
  vim.fn.jobstart({ "cmd.exe", "/c", "start", "", "explorer", path }, { detach = true })
end

keymap.set("n", "<leader>ev", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  if ft == "neo-tree" then
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if ok then
      local state = manager.get_state("filesystem")
      local node = state.tree:get_node()
      if node and node.path then
        vim.fn.jobstart({ "cmd.exe", "/c", "start", '""', node.path }, { detach = true })
      end
    end
  else
    open_explorer(vim.fn.expand("%:p:h"))
  end
end, { desc = "File Preview" })


vim.keymap.set({"n", "t"}, "<leader>e]", "5<C-w>>", { desc = "+Resize horizontally" })
vim.keymap.set({"n", "t"}, "<leader>e[", "5<C-w><", { desc = "-Resize horizontally" })
vim.keymap.set({"n", "t"}, "<leader>e+", "5<C-w>+", { desc = "+Resize vertically" })
vim.keymap.set({"n", "t"}, "<leader>e-", "5<C-w>-", { desc = "-Resize vertically" })

-- =============================================
-- <leader>e	--> End Explorer Functionalities



-- <leader>s	--> Begin AutoSession Functionalities
-- ==================================================
keymap.set("n", "<leader>sr", "<cmd>AutoSession restore<CR>")
keymap.set("n", "<leader>ss", "<cmd>AutoSession save<CR>")
keymap.set("n", "<leader>sf", "<cmd>AutoSession search<CR>")
-- ================================================
-- <leader>s	--> End AutoSession Functionalities



-- <leader>n	--> Begin Logging Functionalities
-- ==============================================
keymap.set("n", "<leader>na", "<cmd>Noice messages<cr>", { desc = "Noice messages" })
keymap.set("n", "<leader>nl", "<cmd>Noice last<cr>", { desc = "Last Noice message" })
keymap.set("n", "<leader>ne", "<cmd>Noice errors<cr>", { desc = "Noice errors" })
keymap.set("n", "<leader>nx", "<cmd>Noice dismiss<cr>", { desc = "Dismiss Noice" })
keymap.set("n", "<leader>nf", "<cmd>Telescope noice<cr>", { desc = "Search Noice messages" })
-- ============================================
-- <leader>n	--> End Logging Functionalities


-- <leader>c	--> Begin CMake Functionalities
-- ==============================================
local opts = { noremap = true, silent = true }
keymap.set("n", "<leader>cg", "<cmd>CMakeGenerate<CR>", vim.tbl_extend("force", opts, { desc = "CMake Generate" }))
keymap.set("n", "<leader>cb", "<cmd>CMakeBuild<CR>",    vim.tbl_extend("force", opts, { desc = "CMake Build" }))
keymap.set("n", "<leader>cr", "<cmd>CMakeRun<CR>",      vim.tbl_extend("force", opts, { desc = "CMake Run" }))
keymap.set("n", "<leader>c]", "<cmd>cnext<cr>", { desc = "Next error" })
keymap.set("n", "<leader>c[", "<cmd>cprev<cr>", { desc = "Prev error" })
-- ============================================
-- <leader>c	--> End CMake Functionalities



-- Miscellaneous
keymap.set("n", "/", "*", { noremap = true, silent = true })  -- search word under cursor

--keymap.set("n", "<leader>/", "/", { noremap = true })		  -- enter word to search
vim.keymap.set("n", "<leader>/", function()
  vim.ui.input({ prompt = "Find > " }, function(input)
    if input == nil or input == "" then
      return
    end
    -- set the search register and jump to first match
    vim.fn.setreg("/", input)
    vim.cmd("normal! n")
  end)
end)


-- 🔹 Colorscheme switcher
local themes = {
  "dayfox",
  "nightfox",
  "terafox",
  "dawnfox",
  "carbonfox",
  "catppuccin-latte",
  "catppuccin-frappe",
  "catppuccin-macchiato",
  "catppuccin-mocha",
  "gruvbox-material",
  "onedark",
  "onelight",
  "onedark_vivid",
  "onedark_dark",
  "vaporwave",
  "nord",
  "kanagawa-wave",
  "kanagawa-dragon",
  "kanagawa-lotus",
  "github_dark",
  "github_dark_default",
  "github_dark_dimmed",
  "github_dark_high_contrast",
  "github_light",
  "github_light_default",
  "github_light_high_contrast",
  
}

local function select_colorscheme()
  vim.ui.select(themes, {
    prompt = "Select colorscheme",
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd.colorscheme(choice)
  end)
end

vim.keymap.set("n", "<leader>mc", select_colorscheme, {
  desc = "Choose colorscheme",
})


-- Word/Line selection keymaps in insert mode
keymap.set('i', '<A-Up>', '<Esc>viw', { desc = 'Insert→select inner word' })
keymap.set('i', '<A-Left>', '<Esc>v0', { desc = 'Insert→BOL selection' })
keymap.set('i', '<A-Right>', '<Esc>v$', { desc = 'Insert→EOL selection' })
keymap.set('i', '<A-Down>', '<Esc>V',  { desc = 'Insert→Visual (line)' })
keymap.set({ "n", "v" }, "<Up>", "v:count ? 'k' : 'gk'", { expr = true, silent = true })
keymap.set({ "n", "v" }, "<Down>", "v:count ? 'j' : 'gj'", { expr = true, silent = true })
-- Save on Ctrl-S & Exit on Ctrl-X
keymap.set({ "n", "v" }, "<C-s>", ":w<CR>", { silent = true })
keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { silent = true })
keymap.set({ "n", "v" }, "<C-x>", "<Cmd>qa<CR>", { silent = true })
keymap.set("i", "<C-x>", "<Esc><Cmd>qa<CR>", { silent = true })
keymap.set("t", "<C-x>", [[<C-\><C-n><Cmd>qa<CR>]], { silent = true })
keymap.set({ "n", "v" }, "<C-X>", "<Cmd>qa!<CR>", { silent = true })
keymap.set("i", "<C-X>", "<Esc><Cmd>qa!<CR>", { silent = true })
keymap.set("t", "<C-X>", [[<C-\><C-n><Cmd>qa!<CR>]], { silent = true })
keymap.set({ "n", "v" }, "<leader>y", "yiw", { silent = true })
-- replace word under cursor with the last yanked text (register 0)
keymap.set("n", "<leader>p", 'ciw<C-r>0<Esc>', { noremap = true, silent = true })
-- Escape Escape in normal mode: closes Quickfix if focused
--[[
vim.keymap.set("n", "<leader>cq", function()
  local buftype = vim.api.nvim_buf_get_option(0, "buftype")
  local filetype = vim.bo.filetype

  -- If it's the quickfix window
  if buftype == "quickfix" or filetype == "qf" then
    vim.cmd("cclose")
  end
end, { desc = "Close Quickfix" })
]]


-- Disable the following keymaps
local opts = { noremap = true, silent = true }
keymap.set("n", "s", "<Nop>", opts)
keymap.set("n", "c", "<Nop>", opts)
keymap.set("n", "r", "<Nop>", opts)
keymap.set("n", "gi", "<Nop>", opts)
keymap.set("n", "S", "<Nop>", opts)
keymap.set("n", "C", "<Nop>", opts)
keymap.set("n", "R", "<Nop>", opts)
keymap.set("n", "gI", "<Nop>", opts)



keymap.set("n", "<leader>?", function()
  require("which-key").show("<leader>")
end, { desc = "Show which-key popup" })

-- Which-Key registration

local wk = require('which-key')

local my_mappings = {
    -- Search
    { "<leader>f", name = "Find", icon = { icon = "󰈞", color = "orange" } },
    { "<leader>ff", desc = "Find Files" },
    { "<leader>fs", desc = "Find String" },
	{ "<leader>fr", desc = "Find all references" },
    { "<leader>fR", desc = "Replace String" },
    { "<leader>fR", desc = "Smart Rename" },
	{ "<leader>ft", desc = "Format File" },
	{ "<leader>fd", desc = "List classes/methods" },
	{ "<leader>fx", desc = "Clear search highlight" },
    

    -- Buffer
    { "<leader>b", name = "Buffer", icon = { icon = "󰓩", color = "white" } },
    { "<leader>b[", desc = "Previous buffer" },
    { "<leader>b]", desc = "Next buffer" },
    { "<leader>b,", desc = "Go to first buffer" },
    { "<leader>b.", desc = "Go to last buffer" },
    { "<leader>bx", desc = "Close buffer" },
    { "<leader>bX", desc = "Close all but current buffer" },
	
	
	-- Build
	{ "<leader>c", name = "Build/Run", icon = { icon = "", color = "yellow" } },
	{ "<leader>cg", desc = "CMake Generate" },
    { "<leader>cb", desc = "CMake Build" },
    { "<leader>cr", desc = "CMake Run" },

    -- Window
    { "<leader>w", name = "Window", icon = { icon = "", color = "orange" } },
    { "<leader>wh", desc = "Horizontal split" },
    { "<leader>wv", desc = "Vertical split" },
    { "<leader>we", desc = "Equalize splits" },
    { "<leader>wx", desc = "Close window" },
    { "<leader>w]", desc = "Next window" },
	{ "<leader>wr<Down>", desc = "Resize height +2" },
    { "<leader>wr<Up>", desc = "Resize height -2" },
    { "<leader>wr<Left>", desc = "Resize width -2" },
    { "<leader>wr<Right>", desc = "Resize width +2" },

    -- Navigation
    { "<leader>g", name = "Navigation", icon = { icon = "󱣱", color = "green" } },
    { "<leader>gp", desc = "Go to previous cursor position" },
	{ "<leader>gn", desc = "Go to next cursor position" },
	{ "<leader>gs", desc = "Go to start of line" },
    { "<leader>ge", desc = "Go to end of line" },
    { "<leader>gS", desc = "Go to first line" },
    { "<leader>gE", desc = "Go to last line" },

    -- Terminal
    { "<leader>t", name = "Terminal", icon = { icon = "", color = "blue" } },
    { "<leader>tf", desc = "Open Floating Terminal" },
    { "<leader>tt", desc = "Open Horizontal Terminal" },
    { "<leader>tr", desc = "Run Application" },
	{ "<leader>ts", desc = "Preview SVG" },
	{ "<leader>tv", desc = "Activate Python venv" },

    -- Project Explorer
    { "<leader>e", name = "Explorer", icon = { icon = "", color = "yellow" } },
    { "<leader>ee", desc = "Toggle Explorer" },
    { "<leader>ef", desc = "Focus Explorer" },
	{ "<leader>ev", desc = "File Preview" },
	{ "<leader>e]", desc = "+Resize Horizontally" },
	{ "<leader>e[", desc = "-Resize Horizontally" },
	{ "<leader>e+", desc = "+Resize Vertically" },
	{ "<leader>e-", desc = "-Resize Vertically" },

    -- Session
    { "<leader>s", name = "Session", icon = { icon = "", color = "blue" } },
    { "<leader>sr", desc = "Restore Session" },
    { "<leader>ss", desc = "Save Session" },
    { "<leader>sf", desc = "Find Sessions" },
	
	-- Logging
	{ "<leader>n", name = "Logging", icon = { icon = "", color = "yellow" } },
    { "<leader>na", desc = "Show all messages" },
	{ "<leader>nl", desc = "Show last message" },
	{ "<leader>ne", desc = "Show errors" },
	{ "<leader>nx", desc = "Exit" },
	{ "<leader>nf", desc = "Search message" },
	
	-- Utilities
	{ "<leader>u", name = "Utilties", icon = { icon = "", color = "magenta" } },
    { "<leader>ub", desc = "Bookmark Toggle" },
	{ "<leader>u]", desc = "Bookmark Next" },
	{ "<leader>u[", desc = "Bookmark Previous" },
	{ "<leader>ua", desc = "Bookmark Show All" },
	{ "<leader>ux", desc = "Bookmark Clear All" },
	
	-- Miscellaneous
    { "<leader>m", name = "Miscellaneous", icon = { icon = "󱧼", color = "green" } },
    { "<leader>mc", desc = "Choose colorscheme" },
	
	
	{ "<leader>/", desc = "find text", hidden=true },
	{ "<leader>xx", desc = "Clear shada file", hidden=true },
	{ "<leader>?", desc = "Launch which-key", hidden=true },
	
	{ "<leader>0",  hidden=true },
	{ "<leader>1",  hidden=true },
	{ "<leader>2",  hidden=true },
	{ "<leader>3",  hidden=true },
	{ "<leader>4",  hidden=true },
	{ "<leader>5",  hidden=true },
	{ "<leader>6",  hidden=true },
	{ "<leader>7",  hidden=true },
	{ "<leader>8",  hidden=true },
	{ "<leader>9",  hidden=true },
	
	{ "<leader>p",  hidden=true },
	{ "<leader>y",  hidden=true },
	{ "<leader>[",  hidden=true },
	{ "<leader>]",  hidden=true },
	{ "<leader><Tab>",  hidden=true },
}

wk.add(my_mappings)



local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>ff", function()
  local fzf = require("fzf-lua")
  local cwd = vim.fn.getcwd()

  fzf.live_grep({
    cwd = cwd,
    prompt = "Find> ",
    previewer = "builtin",
	--[[
    rg_opts = "--vimgrep --smart-case --hidden --color=never --no-heading --fixed-strings"
      .. " --glob !.git/**"
      .. " --glob !build/**"
      .. " --glob !out/**"
      .. " --glob !venv/**"
      .. " --glob !.venv/**"
      .. " --glob !**/site-packages/**"
      .. " --glob !**/sagacity/Lib/**"
      .. " --glob !**/[Ll]ogs/**",
	  --]]
  })
end, { desc = "Find String" })


vim.keymap.set("n", "<leader>fs", function()
    require("fzf-lua").files({
      fzf_opts = {
        ["--exact"] = true,   -- 🔑 disable fuzzy char-by-char matching
      },
    })
  end,
  { desc = "Find Files"})

vim.keymap.set("n", "<leader>fh", function() fzf.oldfiles() end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>f/", function() fzf.grep_cword() end, { desc = "Find word under cursor" })
--vim.keymap.set("n", "<leader>fb", "<cmd>Telescope marks all<CR>", { desc = "Find all bookmarks " })

