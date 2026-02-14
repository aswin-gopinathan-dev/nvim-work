local M = {}

-- =====================================================================


function M.manage_search_settings()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf    = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- 1. Helper to generate the list items dynamically
  local function get_settings_list()
    local results = {
      { type = "flag", name = "Match Case", value = _G.MyConfig.case_sensitive },
      { type = "flag", name = "Whole Word", value = _G.MyConfig.match_whole_word },
    }
    for _, f in ipairs(_G.MyConfig.skip_folders or {}) do
      table.insert(results, { type = "folder", name = f })
    end
    for _, e in ipairs(_G.MyConfig.file_extensions or {}) do
      table.insert(results, { type = "extension", name = e })
    end
    return results
  end

  -- 2. Helper to refresh the window
  local function refresh(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    picker:refresh(finders.new_table({
      results = get_settings_list(),
      entry_maker = function(entry)
        local display = string.format("[%s] %s", entry.type:sub(1,1):upper(), entry.name)
        if entry.type == "flag" then
          display = display .. ": " .. (entry.value and "ON" or "OFF")
        end
        return { value = entry, display = display, ordinal = entry.name }
      end
    }), { reset_prompt = true })
  end

  pickers.new({}, {
    prompt_title = "Search Manager (t: Toggle, f: +Folder, e: +Ext, d: Delete)",
    initial_mode = "normal",
    finder = finders.new_table({
      results = get_settings_list(),
      entry_maker = function(entry)
        local display = string.format("[%s] %s", entry.type:sub(1,1):upper(), entry.name)
        if entry.type == "flag" then
          display = display .. ": " .. (entry.value and "ON" or "OFF")
        end
        return { value = entry, display = display, ordinal = entry.name }
      end
    }),
    sorter = conf.generic_sorter({}),
    layout_config = { width = 0.5, height = 0.5 },
    attach_mappings = function(prompt_bufnr, map)
      local win = vim.api.nvim_get_current_win()

      -- TOGGLE FLAG (t)
      map("n", "t", function()
        local selection = action_state.get_selected_entry()
        if selection and selection.value.type == "flag" then
          if selection.value.name == "Match Case" then
            _G.MyConfig.case_sensitive = not _G.MyConfig.case_sensitive
          else
            _G.MyConfig.match_whole_word = not _G.MyConfig.match_whole_word
          end
          refresh(prompt_bufnr)
        end
      end)

      -- ADD FOLDER (f)
      map("n", "f", function()
        vim.ui.input({ prompt = "Exclude Folder: " }, function(input)
          if input and input ~= "" then
            table.insert(_G.MyConfig.skip_folders, input)
            vim.defer_fn(function() 
              if vim.api.nvim_win_is_valid(win) then 
                vim.api.nvim_set_current_win(win)
                refresh(prompt_bufnr) 
              end 
            end, 10)
          end
        end)
      end)

      -- ADD EXTENSION (e)
      map("n", "e", function()
        vim.ui.input({ prompt = "Include Extension: " }, function(input)
          if input and input ~= "" then
            table.insert(_G.MyConfig.file_extensions, input)
            vim.defer_fn(function() 
              if vim.api.nvim_win_is_valid(win) then 
                vim.api.nvim_set_current_win(win)
                refresh(prompt_bufnr) 
              end 
            end, 10)
          end
        end)
      end)

      -- DELETE (d)
      map("n", "d", function()
        local selection = action_state.get_selected_entry()
        if not selection or selection.value.type == "flag" then return end
        
        local target = (selection.value.type == "folder") and _G.MyConfig.skip_folders or _G.MyConfig.file_extensions
        for i, v in ipairs(target) do
          if v == selection.value.name then
            table.remove(target, i)
            break
          end
        end
        refresh(prompt_bufnr)
      end)

      map("n", "<Esc>", actions.close)
      return true
    end,
  }):find()
end


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
      additional_args = M.text_filter()
    })
  else
    tb.live_grep({
      additional_args = M.text_filter()
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

  require("telescope.builtin").live_grep({
    default_text = text,
	additional_args = M.text_filter()
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
	
    vim.fn.setreg("/", input)
	local found = vim.fn.search(input, "nw")
    if found == 0 then
      vim.notify("Text not found: " .. input, vim.log.levels.INFO)
      return
    end
	
    vim.cmd("silent! normal! n")
  end)
end

function M.text_filter()
  local args = { "--fixed-strings" }   -- remove if you want fuzzy matching
  
-- Check the global flag for whole word matching
  if _G.MyConfig.match_whole_word then
      table.insert(args, "--word-regexp")
  end
  
  -- Check the global flag for Match case
  if _G.MyConfig.case_sensitive then
      table.insert(args, "--case-sensitive")
  else
      -- Optional: explicitly add ignore-case if the global is false
      table.insert(args, "--ignore-case")
  end

  -- Folders to exclude
  for _, name in ipairs(_G.MyConfig.skip_folders or {}) do
    -- turns "env" into "!**/env/**"
    table.insert(args, "--glob")
    table.insert(args, "!**/" .. name .. "/**")
  end

  -- File types to include (optional; empty = no type filter)
  for _, ext in ipairs(_G.MyConfig.file_extensions or {}) do
    -- turns "py" into "**/*.py"
    table.insert(args, "--glob")
    table.insert(args, "**/*." .. ext)
  end

  return args
end


local function lua_pat_escape(s)
  -- Escape Lua pattern magic characters
  return (s:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1"))
end

function M.folder_filter()
 
  local patterns = {}
  for _, name in ipairs(_G.MyConfig.skip_folders or {}) do
    local escaped = lua_pat_escape(name)
    table.insert(patterns, escaped .. "[\\/]")
  end
  
  return patterns
end



local filter_win = nil
local filter_buf = nil

function M.show_find_filters()
  local path = vim.fn.stdpath("config") .. "/lua/config/search_filters.lua"

  -- If popup window is already open, just focus it
  if filter_win and vim.api.nvim_win_is_valid(filter_win) then
    vim.api.nvim_set_current_win(filter_win)
    return
  end

  -- Reuse existing buffer if it exists, otherwise create one
  filter_buf = vim.fn.bufadd(path)
  vim.fn.bufload(filter_buf)  -- load file into buffer
  vim.bo[filter_buf].buflisted = false

  -- Popup size
  local width  = math.floor(vim.o.columns * 0.45)
  local height = math.floor(vim.o.lines * 0.65)

  -- Open floating window with that buffer
  filter_win = vim.api.nvim_open_win(filter_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
	title = " Search Filters ",
	title_pos = "center",
  })

  -- Close helper
  local function close()
    if filter_win and vim.api.nvim_win_is_valid(filter_win) then
      vim.api.nvim_win_close(filter_win, true)
    end
    filter_win = nil
    -- we intentionally do NOT delete the buffer; it stays in the buffer list
    -- so next time we can reuse it via bufadd(path)
  end

  -- q / <Esc> to close (buffer-local)
  vim.keymap.set("n", "q", close, { buffer = filter_buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = filter_buf, nowait = true })
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
	initial_mode = "normal",
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
	  map("n", "x", function()
		  local picker = action_state.get_current_picker(prompt_bufnr)
		  local entry = action_state.get_selected_entry()
		  if not entry or not entry.bufnr then return end

		  local row = picker:get_selection_row()

		  -- delete buffer
		  vim.api.nvim_buf_delete(entry.bufnr, { force = false })

		  -- refresh results
		  picker:refresh(
			finders.new_table({
			  results = vim.fn.getbufinfo({ buflisted = 1 }),
			  entry_maker = function(buf)
				local name = buf.name ~= "" and buf.name or "[No Name]"
				return {
				  value   = buf,
				  ordinal = name,
				  display = vim.fn.fnamemodify(name, ":t"),
				  bufnr   = buf.bufnr,
				}
			  end,
			}),
			{ reset_prompt = false }
		  )

		  -- move cursor to same row (or next if last)
		  local new_count = #vim.fn.getbufinfo({ buflisted = 1 })
		  if row >= new_count then
			row = new_count - 1
		  end
		  if row >= 0 then
			picker:set_selection(row)
		  end
		end)

      return true
    end,
  }):find()
end

return M