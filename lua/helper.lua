local M = {}

-- =====================================================================

function M.format_file()
  local ft = vim.bo.filetype

  if ft == "qml" then
    vim.cmd("silent !qmlformat -i %")
    vim.cmd("edit")
  else
    vim.lsp.buf.format({ async = true })
  end
end


function M.find_word_under_cursor()
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
end


function M.find_selected_word()  -- Search selected text --> Press viw in normal to highlight the word under cursor
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
end


function M.find_classes_and_methods()
  local aerial = require("aerial")
  aerial.open({ direction = "float", focus = true })
end


-- =====================================================================

function M.activate_next_window()
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
end


function M.resize_window()
  local key = vim.fn.keytrans(vim.fn.getcharstr())
  local map = {
    ["<Left>"]  = "5<C-w><",
    ["<Right>"] = "5<C-w>>",
    ["<Up>"]    = "5<C-w>+",
    ["<Down>"]  = "5<C-w>-",
  }

  local cmd = map[key]
  if cmd then
    local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
  end
end


-- =====================================================================

local function close_quickfix()
  local wininfo = vim.fn.getwininfo()
  for _, win in ipairs(wininfo) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
    end
  end
end


function M.open_terminal_floating()
  close_quickfix()
  local cwd = vim.fn.getcwd()
  vim.cmd(string.format("ToggleTerm dir=%s direction=float", cwd))
end


function M.open_terminal_horizontal()
  close_quickfix()
  local cwd = vim.fn.getcwd()
  vim.cmd(string.format("ToggleTerm dir=%s direction=horizontal", cwd))
end


-- Preview the SVG PathSvg { path: "..." } under cursor
-- Usage: put cursor anywhere inside the quoted path string, press the shortcut
function M.preview_svg()
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


function M.run_app()
  local src_buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(src_buf) -- absolute path or "" for non-file buffers
  local ext  = vim.fn.fnamemodify(file, ":e")
  
  local cwd = vim.fn.getcwd()
  local drive = cwd:sub(1, 2)

  local cmd
  if ext == "qml" then
    cmd = string.format('qml.exe "%s"', file)
  else
    cmd = "python .\\entrypoint.py"
  end
  
  launch_app(cmd)
end


function M.run_app2()
  vim.cmd("write")
  vim.cmd("stopinsert")
  launch_app("python .\\entrypoint.py")
end


function M.close_terminal()
  local ok, term = pcall(require, "toggleterm.terminal")
  if not ok then return end

  -- Close all open toggleterm terminals
  for _, t in pairs(term.get_all()) do
    if t:is_open() then
      t:close()
    end
  end
end


-- =====================================================================

local function open_explorer(path)
  if not path or path == "" then
    path = vim.fn.expand("%:p")
  end
  if path == "" then
    path = vim.fn.getcwd()
  end

  path = vim.fn.fnamemodify(path, ":p")
  path = path:gsub("/", "\\")

  local is_file = vim.fn.filereadable(path) == 1
  local cmd
  if is_file then
    cmd = 'start "" explorer.exe /select,"' .. path .. '"'
  else
    cmd = 'start "" explorer.exe "' .. path .. '"'
  end

  vim.fn.system({ "cmd.exe", "/C", cmd })
end


function M.preview_file()
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
    open_explorer(vim.fn.expand("%:p"))
  end
end

-- =====================================================================

function M.find_word()
  vim.ui.input({ prompt = "Find > " }, function(input)
    if input == nil or input == "" then
      return
    end
    -- set the search register and jump to first match
    vim.fn.setreg("/", input)
    vim.cmd("normal! n")
  end)
end


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

function M.select_colorscheme()
  vim.ui.select(themes, {
    prompt = "Select colorscheme",
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd.colorscheme(choice)
  end)
end


-- =====================================================================


-- =====================================================================

function M.close_debugger()
  require'dap'.disconnect({ terminateDebuggee = true })
  require'dap'.close()
  require'dapui'.close()
end


local function dapui_preset(left_idx, bottom_idx)
  local dapui = require("dapui")
  dapui.close()

  if left_idx then
    dapui.open({ layout = left_idx, reset = true })
  end
  if bottom_idx then
    dapui.open({ layout = bottom_idx, reset = true })
  end
end


local function get_visual_selection_exact()
  -- save/restore a scratch register (z)
  local save, savetype = vim.fn.getreg('z'), vim.fn.getregtype('z')
  vim.cmd([[silent noautocmd normal! "zy]])   -- yank current visual selection to register z
  local text = vim.fn.getreg('z')
  vim.fn.setreg('z', save, savetype)          -- restore register z
  return text
end


function M.add_debug_watch()
  local expr = get_visual_selection_exact()
    :gsub("^%s+", "")
    :gsub("%s+$", "")
    :gsub("\n+", " ")

  if expr ~= "" then
    local ok, err = pcall(function()
      require('dapui').elements.watches.add(expr)
    end)
    if not ok then
      vim.notify("Failed to add watch: " .. tostring(err), vim.log.levels.WARN)
    end
  else
    vim.notify("No valid selection to watch", vim.log.levels.INFO)
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end


local layouts = {
  { label = "Full", scopes = 1, console = 4 },
  { label = "Variables",               scopes = 1, console = nil },
  { label = "Locals",                  scopes = 2, console = nil },
  { label = "Watch",                   scopes = 3, console = nil },
  { label = "Stack",                   scopes = 6, console = nil },
  { label = "Console",                 scopes = nil, console = 5 },
}

function M.select_debug_layout()
  vim.ui.select(
    layouts,
    {
      prompt = "DAP UI layout:",
      format_item = function(item)
        return item.label
      end,
    },
    function(choice)
      if not choice then
        return
      end
      dapui_preset(choice.scopes, choice.console)
    end
  )
end


function M.close_floating_windows()
  -- Close diagnostic float if one exists
  for _, win in ipairs(vim.api.nvim_list_wins()) do
	local config = vim.api.nvim_win_get_config(win)
	if config.relative ~= "" then
	  vim.api.nvim_win_close(win, true)
	  return
	end
  end

  -- Otherwise behave like normal <Esc>
  vim.cmd("nohlsearch")
end


function M.toggle_lsp()
	  local running = {}
	  for _, client in pairs(vim.lsp.get_active_clients()) do
		running[client.name] = true
	  end

	  local stopped_any = false

	  for _, name in ipairs({ "pyright", "basedpyright", "mypy_lsp" }) do
		if running[name] then
		  vim.cmd("LspStop " .. name)
		  stopped_any = true
		end
	  end

	  if stopped_any then
		vim.notify("Pyright / Mypy stopped", vim.log.levels.INFO)
	  else
		vim.cmd("LspStart pyright")
		vim.cmd("LspStart mypy_lsp")
		vim.notify("Pyright / Mypy started", vim.log.levels.INFO)
	  end
	end

-- =====================================================================


-- =====================================================================


-- =====================================================================


-- =====================================================================


-- =====================================================================


-- =====================================================================

function M.smart_close_buffer()
  -- Closing the current buffer will mess up the dimensions of other buffers (like neotree, terminal) in the 
  -- current window. Avoid this by switching to another buffer on closing the current buffer. 
  local bufnr = vim.api.nvim_get_current_buf()
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed > 1 then
    vim.cmd("bprevious")
  else
    vim.cmd("enew")
  end
  vim.cmd("bdelete " .. bufnr)
end


-- =====================================================================


function M.get_files_list()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf    = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Get all listed buffers
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  if vim.tbl_isempty(bufs) then
    vim.notify("No listed buffers", vim.log.levels.INFO)
    return
  end
  
  table.sort(bufs, function(a, b)
    local name_a = vim.fn.fnamemodify(a.name ~= "" and a.name or "[No Name]", ":t"):lower()
    local name_b = vim.fn.fnamemodify(b.name ~= "" and b.name or "[No Name]", ":t"):lower()
    return name_a > name_b
  end)

  pickers.new({}, {
    prompt_title = "Buffers",
    finder = finders.new_table({
      results = bufs,
      entry_maker = function(buf)
        local name = buf.name ~= "" and buf.name or "[No Name]"
        return {
          value   = buf,
          ordinal = name,                                  -- for sorting
          display = vim.fn.fnamemodify(name, ":t"),        -- 👈 filename only
          bufnr   = buf.bufnr,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = false,
    layout_strategy = "center",
    layout_config = {
      width  = 0.35,
      height = 0.80,
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if entry and entry.bufnr then
          vim.api.nvim_set_current_buf(entry.bufnr)
        end
      end)
      return true
    end,
  }):find()
end

return M