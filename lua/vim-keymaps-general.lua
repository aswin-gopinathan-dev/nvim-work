local keymap = vim.keymap
local helper = require("helper")


-- <leader>f	--> Begin Find Functionalities
-- ===========================================

local builtin = require("telescope.builtin")
keymap.set("n", "<leader>ff", builtin.live_grep, {desc = "Find String"})
keymap.set("n", "<leader>fs", builtin.find_files, { desc = "Find files" })
keymap.set("n", "<leader>fg", builtin.resume, { desc = "Resume last find",})
keymap.set("n", "<leader>fh", function() require("spectre").open() end, { desc = "Replace string" })
keymap.set("n", "<leader>ft", helper.format_file, {desc="Format File"})
keymap.set("n", "<leader>fo", builtin.oldfiles, {desc = "Find old files"})
keymap.set("n", "<leader>f/", helper.find_word_under_cursor, { desc = "Find word under cursor" })
keymap.set('n', '<leader>fr', builtin.lsp_references, { noremap = true, silent = true })
keymap.set("v", "<leader>f/", helper.find_selected_word, { desc = "Live Grep Visual Selection" })
keymap.set('n', '<leader>fx', ':nohlsearch<CR>')
keymap.set("n", "<leader>fd", helper.find_classes_and_methods, { desc = "List classes/methods" })
-- =========================================
-- <leader>f	--> End Find Functionalities



-- <leader>b	--> Begin Tab Functionalities
-- ===========================================
keymap.set("n", "<leader>b[", "<Cmd>BufferLineCyclePrev<CR>")
keymap.set("n", "<leader>b]", "<Cmd>BufferLineCycleNext<CR>")
keymap.set("n", "<leader>b,", "<Cmd>BufferLineGoToBuffer 1<CR>")
keymap.set("n", "<leader>b.", "<Cmd>BufferLineGoToBuffer -1<CR>")
keymap.set("n", "<leader>bX", "<Cmd>BufferLineCloseOthers<CR>")
keymap.set("n", '<leader><Right>', '<Cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })
keymap.set("n", "<leader><tab>", "<cmd>b#<CR>", { noremap = true, silent = true })
keymap.set("n", '<leader><Left>', '<Cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true })
keymap.set("n", "<leader>bx", helper.smart_close_buffer, { silent = true, noremap = true })
keymap.set("n", "<leader>bl", helper.get_files_list, { desc = "Buffer list (filenames only)" })

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    vim.cmd("BufferLineGoToBuffer " .. i)
  end, { silent = true, desc = nil })
end

local gs = require("gitsigns")
vim.keymap.set("n", "<leader>b/", gs.next_hunk, { desc = "Next hunk" })
vim.keymap.set("n", "<leader>b\\", gs.prev_hunk, { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>bp", gs.preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>bd", gs.diffthis, { desc = "Diff this" })
vim.keymap.set("n", "<leader>bD", function() gs.diffthis("~") end, { desc = "Diff against last commit" })
-- ========================================
-- <leader>b	--> End Tab Functionalities



-- <leader>w	--> Begin Window Functionalities
-- =============================================
keymap.set("n", "<leader>wh", "<C-w>v")
keymap.set("n", "<leader>wv", "<C-w>s")
keymap.set("n", "<leader>we", "<C-w>=")
keymap.set("n", "<leader>w", helper.resize_window)
keymap.set('n', '<leader>w]', helper.activate_next_window)
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
vim.keymap.set("n", "<leader>tf", helper.open_terminal_floating, { desc = "Open Floating Terminal" })
vim.keymap.set("n", "<leader>tt", helper.open_terminal_horizontal, { desc = "Open Horizontal Terminal" })
keymap.set("t", "<leader>tt", "<Cmd>ToggleTerm<CR>")
keymap.set("n", "<leader>ts", helper.preview_svg, { desc = 'Preview SVG' })
keymap.set("n", "<F8>", helper.preview_svg, { desc = 'Preview SVG' })
keymap.set("n", "<leader>tr", helper.run_app, { desc = "Run Application" })
keymap.set({ "n", "i" }, "<F7>", helper.run_app2)
keymap.set({ "t" }, "<Esc><Esc>", helper.close_terminal)
-- <leader>tv mapping is in py-venv.lua
-- =============================================
-- <leader>t	--> End Terminal Functionalities



-- <leader>e	--> Begin Explorer Functionalities
-- ===============================================
keymap.set("n", "<leader>ee", ":Neotree toggle<CR>")
keymap.set("n", "<leader>ef", ":Neotree focus<CR>")
keymap.set("n", "<leader>ev", helper.preview_file, { desc = "File Preview" })
-- =============================================
-- <leader>e	--> End Explorer Functionalities



-- <leader>s	--> Begin AutoSession Functionalities
-- ==================================================
keymap.set("n", "<leader>sr", "<cmd>AutoSession restore<CR>")
keymap.set("n", "<leader>ss", "<cmd>AutoSession save<CR>")
keymap.set("n", "<leader>sf", "<cmd>AutoSession search<CR>")
-- ================================================
-- <leader>s	--> End AutoSession Functionalities



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
keymap.set("n", "<leader>q", ":qa<CR>")
keymap.set("n", "/", "*", { noremap = true, silent = true })  -- search word under cursor
keymap.set("n", "<leader>/", helper.find_word)

keymap.set("n", "<leader>mc", helper.select_colorscheme, { desc = "Choose colorscheme", })

keymap.set("n", "<leader>mb", "<Plug>(Marks-toggle-bookmark0)", {silent = true})
keymap.set("n", "<leader>m]", "<Plug>(Marks-next-bookmark0)", {silent = true})
keymap.set("n", "<leader>m[", "<Plug>(Marks-prev-bookmark0)", {silent = true})
keymap.set("n", "<leader>ml", "<cmd>BookmarksListAll<CR>")


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


