local keymap = vim.keymap

-- Debugger
keymap.set('n', '<F5>', function() require('neo-tree').close_all(); require('dap').continue() end)
keymap.set('n', '<F10>', function() require('dap').step_over() end)
keymap.set('n', '<F11>', function() require('dap').step_into() end)
keymap.set('n', '<leader><F10>', function() require('dap').step_out() end, { desc = "which_key_ignore" })
keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)
keymap.set('n', '<leader><F9>', function() require('dap').set_breakpoint() end, { desc = "which_key_ignore" })
keymap.set('n', '<leader><F5>', function()
  require'dap'.disconnect({ terminateDebuggee = true })
  require'dap'.close()
  require'dapui'.close()
end, { desc = "which_key_ignore" })


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



-- <leader>l	--> Begin Layout Functionalities
-- =============================================
vim.keymap.set("n", "<leader>lf", function() dapui_preset(1, 4) end, { desc = "Layout: Full" })
vim.keymap.set("n", "<leader>lv", function() dapui_preset(1, nil) end, { desc = "Layout: Variables" })
vim.keymap.set("n", "<leader>lw", function() dapui_preset(3, nil) end, { desc = "Layout: Watch" })
vim.keymap.set("n", "<leader>ll", function() dapui_preset(2, nil) end, { desc = "Layout: Locals" })
vim.keymap.set("n", "<leader>ls", function() dapui_preset(6, nil) end, { desc = "Layout: Stack" })
vim.keymap.set("n", "<leader>lc", function() dapui_preset(nil, 5) end, { desc = "Layout: Console" })
-- ===========================================
-- <leader>l	--> End Layout Functionalities



-- <leader>d	--> Begin Debug Functionalities
-- ============================================
local function get_visual_selection_exact()
  -- save/restore a scratch register (z)
  local save, savetype = vim.fn.getreg('z'), vim.fn.getregtype('z')
  vim.cmd([[silent noautocmd normal! "zy]])   -- yank current visual selection to register z
  local text = vim.fn.getreg('z')
  vim.fn.setreg('z', save, savetype)          -- restore register z
  return text
end

keymap.set('v', '<F12>', function()
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
end, { desc = "DAP UI: add watch from visual selection", silent = true })


keymap.set('n', '<F12>', function() require('dapui').elements.watches.add(vim.fn.expand('<cword>')) end)
keymap.set('n', '<leader>ds', function() require("dapui").float_element("stacks", {width=70,height=20,enter=true}) end)
keymap.set('n', '<leader>db', function() require("dapui").float_element("breakpoints", {width=70,height=20,enter=true}) end)
-- ==========================================
-- <leader>d	--> End Debug Functionalities



local wk = require('which-key')

local my_mappings = {
    -- Debugger 
    { "<leader>d", group = "Debug" },
    { "<leader>d<F5>", "<F5>", desc = "Start Debugging" },
	{ "<leader>d<F9>", "<F9>", desc = "Toggle Breakpoint" },
	{ "<leader>d<F10>", "<F10>", desc = "Step Over" },
	{ "<leader>d<F11>", "<F11>", desc = "Step Into" },
	{ "<leader>d<F12>", "<F12>", desc = "Add Watch" },
	{ "<leader>db", desc = "Breakpoints" },
	{ "<leader>ds", desc = "Call Stack" },
	  
	{ "<leader>d<Space><F5>", "<leader><F5>", desc = "Stop Debugging" },
	{ "<leader>d<Space><F9>", "<leader><F9>", desc = "Set Breakpoint" },
	{ "<leader>d<Space><F10>", "<leader><F10>", desc = "Step Out" },
	  
	
	{ "<leader>l", name = "Debug Layouts", icon = { icon = "", color = "red" }},
	{ "<leader>lf", desc = "Layout: Full" },
	{ "<leader>lv", desc = "Layout: Variables" },
	{ "<leader>lw", desc = "Layout: Watch" },
	{ "<leader>ll", desc = "Layout: Locals" },
	{ "<leader>ls", desc = "Layout: Stack" },
	{ "<leader>lc", desc = "Layout: Console" },

    -- LSP
    { "<leader>g", name = "LSP/Diagnostics", icon = { icon = "󰒋", color = "green" } },
    { "<leader>gr", desc = "Show All References" },
    { "<leader>gD", desc = "Go to Declaration" },
    { "<leader>gd", desc = "Go to Definitions" },
    { "<leader>gk", desc = "Show Documentation" },
    { "<leader>ga", desc = "Code Actions" },
    { "<leader>gH", desc = "Show Buffer Diagnostics" },
    { "<leader>gh", desc = "Show Line Diagnostics" },
    { "<leader>gp", desc = "Previous Diagnostic" },
    { "<leader>gn", desc = "Next Diagnostic" },
	{ "<leader>gx", desc = "Activate/Deactivate LSP"},
	{ "<leader>g[", desc = "Go to previous cursor" },
    { "<leader>g]", desc = "Go to next cursor" },
}

wk.add(my_mappings)



-- LSP Shortcuts
local M = {}
function M.MapLspKeys(ev)
  local opts = { buffer = ev.buf, silent = true }
  
-- <leader>g	--> Begin LSP/Diagnostics Functionalities
-- ======================================================
  keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, {desc="Show all references"}))
  keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, {desc="Go to declaration"}))
  keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", vim.tbl_extend("force", opts, {desc="Go to definitions"}))
  keymap.set({"n", "v"}, "<leader>ga", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {desc="See available code actions"}))
  keymap.set("n", "<leader>gk", function()
	vim.lsp.buf.hover({
		border = 'rounded',
	})
  end, vim.tbl_extend("force", opts, {desc="Show documentation"}))
  keymap.set("n", "<leader>gH", "<cmd>Telescope diagnostics bufnr=0<CR>", vim.tbl_extend("force", opts, {desc="Show buffer diagnostics"}))
  keymap.set("n", "<leader>gh", function()
	  vim.diagnostic.open_float(nil, {
		border = "rounded",
		scope = "line",
		focusable = false,
	  })
	end, vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))
  keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, {desc="Go to previous diagnostic"}))
  keymap.set("n", "<leader>gn", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, {desc="Go to next diagnostic"}))
  
    keymap.set("n", "<leader>gx", function()
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
	end, { desc = "Activate/Deactivate LSP" })
-- ====================================================
-- <leader>g	--> End LSP/Diagnostics Functionalities
  
  
  
	keymap.set("n", "<leader>fR", vim.lsp.buf.rename, vim.tbl_extend("force", opts, {desc="Smart rename"}))
	vim.keymap.set("n", "<Esc>", function()
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
	end, { desc = "Close floating windows / clear hlsearch" })

end

return M
