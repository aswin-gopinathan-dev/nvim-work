return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
		"mfussenegger/nvim-dap-python",		
    },
	
	opts = {
		layouts = 
		{
			{
				elements = 
				{
					{ id = "scopes", size = 0.50 },
					--{ id = "breakpoints", size = 0.00 },
					--{ id = "stacks", size = 0.20 },
					{ id = "watches", size = 0.50 },
				},
				position = "left",
				size = 45,
			},
			{
				elements = 
				{
					{ id = "console", size = 0.5 },
					{ id = "stacks", size = 0.5 },
					-- { id = "repl", size = 0.5 },
				},
				position = "bottom",
				size = 8,
			},
			
		},
	},
	
  
    config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
		
		local layouts_left_full = {
		  {
			elements = {
			  { id = "scopes",  size = 0.60 },
			  { id = "watches", size = 0.40 },
			},
			size = 45,
			position = "left",
		  },
		}

		local layouts_left_scopes = {
		  {
			elements = { { id = "scopes", size = 1.0 } },
			size = 45,
			position = "left",
		  },
		}

		local layouts_left_watches = {
		  {
			elements = { { id = "watches", size = 1.0 } },
			size = 45,
			position = "left",
		  },
		}

		local layouts_bottom_full = {
		  {
			elements = {
			  { id = "console", size = 0.50 },
			  { id = "stacks",  size = 0.50 },
			},
			size = 8,
			position = "bottom",
		  },
		}

		local layouts_bottom_console = {
		  {
			elements = { { id = "console", size = 1.0 } },
			size = 12,
			position = "bottom",
		  },
		}

		local layouts_left_stacks = {
		  {
			elements = { { id = "stacks", size = 1.0 } },
			size = 45,
			position = "left",
		  },
		}
		
		local layouts_master = {
		  layouts_left_full[1],       -- 1
		  layouts_left_scopes[1],     -- 2
		  layouts_left_watches[1],    -- 3
		  layouts_bottom_full[1],     -- 4
		  layouts_bottom_console[1],  -- 5
		  layouts_left_stacks[1],   -- 6
		}

		dapui.setup({ layouts = layouts_master })

		
		local function pick_exe()
		  local cwd = vim.fn.getcwd()
		  local exe_dir = cwd .. "\\out\\Debug"

		  local exes = vim.fn.globpath(exe_dir, "*.exe", false, true)
		  if #exes == 0 then
			vim.notify("No executable found in " .. exe_dir, vim.log.levels.ERROR)
			return nil
		  end

		  -- pick the most recently modified exe
		  table.sort(exes, function(a, b)
			return vim.fn.getftime(a) > vim.fn.getftime(b)
		  end)

		  return exes[1]
		end


		local mason_path = vim.fn.stdpath("data") .. "\\mason\\"
		local codelldb_path = mason_path .. "packages\\codelldb\\extension\\adapter\\codelldb.exe"

		dap.adapters.codelldb = {
		  type = "server",
		  port = "${port}",
		  executable = {
			command = codelldb_path,
			args = { "--port", "${port}" },
			detached = false,
		  },
		  enrich_config = function(config, on_config)
				dap.set_log_level("TRACE")
				on_config(config)
			  end,
		}
		
        dap.configurations.cpp = {
            {
                name = "Launch",
                type = "codelldb",
                request = "launch",
				program = pick_exe,
				cwd = "${workspaceFolder}",
	
                stopOnEntry = false,
                args = {},
				
				runInTerminal = false,      -- launch in a real terminal
				console = "internalConsole", -- send output to terminal, not just internal pipe
            },
        }
 
		dap.adapters.python = {
		  type = "executable",
		  command = vim.fn.getcwd() .. "\\.venv\\Scripts\\python.exe",
		  args = { "-m", "debugpy.adapter" },
		}

	
		local python_path = vim.fn.getcwd() .. "\\.venv\\Scripts\\python.exe"
		require("dap-python").setup(python_path)

		dap.configurations.python = {
		  {
			type = "python",
			request = "launch",
			name = "Sagacity Desktop",
			program = "${workspaceFolder}\\entrypoint.py",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			justMyCode = false,
			subProcess = true,			
		  },
		}

		
		local nio = require("nio")
		nio.api.nvim_buf_set_name(dapui.elements.scopes.buffer(), "Locals")
		nio.api.nvim_buf_set_name(dapui.elements.stacks.buffer(), "Call Stack")
		nio.api.nvim_buf_set_name(dapui.elements.watches.buffer(), "Watch")
		nio.api.nvim_buf_set_name(dapui.elements.breakpoints.buffer(), "Breakpoints")
		nio.api.nvim_buf_set_name(dapui.elements.console.buffer(), "Console")
		
		vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ", [vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ", [vim.diagnostic.severity.HINT] = "󰠠 ",
			},
			linehl = {
				[vim.diagnostic.severity.ERROR] = "Error", [vim.diagnostic.severity.WARN] = "Warn",
				[vim.diagnostic.severity.INFO] = "Info", [vim.diagnostic.severity.HINT] = "Hint",
			},
		  },
		})
		
		vim.fn.sign_define("DapBreakpoint", { text = "🐞" })
		vim.fn.sign_define("DapStopped", { text = "" })

		dap.listeners.before.attach.dapui_config = function() dapui.open() end
		dap.listeners.before.launch.dapui_config = function() 
													 dapui.open() 
													 dapui.close()
													 dapui.open({ layout = 1, reset = true })
													 dapui.open({ layout = 4, reset = true }) 
												   end
		dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
		dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
	
    end,
}
