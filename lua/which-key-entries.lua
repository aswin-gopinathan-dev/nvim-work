-- Which-Key registration

local wk = require('which-key')

local my_mappings = {
    -- Search
    { "<leader>f", name = "Find", icon = { icon = "󰈞", color = "orange" } },
    { "<leader>ff", desc = "Find String" },
    { "<leader>fs", desc = "Find Files" },
	{ "<leader>fr", desc = "Find all references" },
	{ "<leader>fg", desc = "Resume last find" },
	{ "<leader>fo", desc = "Find olf files" },
	{ "<leader>f/", desc = "Find word under cursor" },
    { "<leader>fh", desc = "Replace String" },
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
	{ "<leader>bl", desc = "File list" },
	
	
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
    { "<leader>w]", desc = "Next window" },
	{ "<leader>w?", desc = "Resize window with arrow keys" },

    -- Navigation
    { "<leader>g", name = "Navigation", icon = { icon = "󱣱", color = "green" } },
    { "<leader>g[", desc = "Go to previous cursor position" },
	{ "<leader>g]", desc = "Go to next cursor position" },
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

    -- Session
    { "<leader>s", name = "Session", icon = { icon = "", color = "blue" } },
    { "<leader>sr", desc = "Restore Session" },
    { "<leader>ss", desc = "Save Session" },
    { "<leader>sf", desc = "Find Sessions" },
		
	-- Miscellaneous
    { "<leader>m", name = "Miscellaneous", icon = { icon = "󱧼", color = "green" } },
    { "<leader>mc", desc = "Choose Theme" },
	{ "<leader>mb", desc = "Toggle(Bookmark)" },
	{ "<leader>m]", desc = "Next(Bookmark)" },
	{ "<leader>m[", desc = "Previous(Bookmark)" },
	{ "<leader>ml", desc = "Show All(Bookmark)" },
	
	-- Debugger 
    { "<leader>d", group = "Debug" },
    { "<leader>d<F5>", "<F5>", desc = "Start Debugging" },
	{ "<leader>d<F9>", "<F9>", desc = "Toggle Breakpoint" },
	{ "<leader>d<F10>", "<F10>", desc = "Step Over" },
	{ "<leader>d<F11>", "<F11>", desc = "Step Into" },
	{ "<leader>d<F12>", "<F12>", desc = "Add Watch" },
	{ "<leader>db", desc = "Breakpoints" },
	{ "<leader>ds", desc = "Call Stack" },
	{ "<leader>dl", desc = "Layouts" },
	{ "<leader>d<Space><F5>", "<leader><F5>", desc = "Stop Debugging" },
	{ "<leader>d<Space><F9>", "<leader><F9>", desc = "Set Breakpoint" },
	{ "<leader>d<Space><F10>", "<leader><F10>", desc = "Step Out" },

    -- LSP
    { "<leader>h", name = "LSP", icon = { icon = "󰒋", color = "green" } },
    { "<leader>hr", desc = "Show All References" },
    { "<leader>hD", desc = "Go to Declaration" },
    { "<leader>hd", desc = "Go to Definitions" },
    { "<leader>hk", desc = "Show Documentation" },
    { "<leader>ha", desc = "Code Actions" },
    { "<leader>hH", desc = "Show Buffer Diagnostics" },
    { "<leader>hh", desc = "Show Line Diagnostics" },
    { "<leader>h[", desc = "Previous Diagnostic" },
    { "<leader>h]", desc = "Next Diagnostic" },
	{ "<leader>hx", desc = "Activate/Deactivate LSP"},
	
	
	-- Hidden keys
	{ "<leader>/", desc = "find text", hidden=true },
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
	{ "<leader><Up>",  hidden=true },
	{ "<leader><Down>",  hidden=true },
	{ "<leader><Left>",  hidden=true },
	{ "<leader><Right>",  hidden=true },
	{ "<leader><PageUp>",  hidden=true },
	{ "<leader><PageDown>",  hidden=true },
	{ "<leader>q",  hidden=true },
}

wk.add(my_mappings)

