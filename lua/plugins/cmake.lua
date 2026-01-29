return { 
	'Civitasv/cmake-tools.nvim', 
	config = function()
		local osys = require("cmake-tools.osys")
		require("cmake-tools").setup {
		  cmake_command = "cmake", -- this is used to specify cmake command path
		  ctest_command = "ctest", -- this is used to specify ctest command path
		  cmake_use_preset = false,
		  cmake_regenerate_on_save = false, -- auto generate when save CMakeLists.txt
		  cmake_generate_options = {
			  "-G", "Ninja",
			  "-DCMAKE_CXX_COMPILER=clang-cl",
			  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
			},
		  cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
		  -- support macro expansion:
		  --       ${kit}
		  --       ${kitGenerator}
		  --       ${variant:xx}
		  cmake_build_directory = function()
			if osys.iswin32 then
			  return "out\\${variant:buildType}"
			end
			return "out/${variant:buildType}"
		  end, -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
		  cmake_compile_commands_options = {
				action = "copy",
				target = vim.loop.cwd(),
			},
		  cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
		  cmake_variants_message = {
			short = { show = true }, -- whether to show short message
			long = { show = true, max_length = 40 }, -- whether to show long message
		  },
		  cmake_dap_configuration = { -- debug settings for cmake
			name = "cpp",
			type = "codelldb",
			request = "launch",
			stopOnEntry = false,
			runInTerminal = true,
			console = "integratedTerminal",
		  },
		  cmake_executor = { -- executor to use
			name = "quickfix", -- name of the executor
			opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
			default_opts = { -- a list of default and possible values for executors
			  quickfix = {
				  show = "always",
				  position = "belowright",
				  size = 10,
				  auto_close_when_success = false,
				},
			  toggleterm = {
				direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
				close_on_exit = false, -- whether close the terminal when exit
				auto_scroll = true, -- whether auto scroll to the bottom
				singleton = true, -- single instance, autocloses the opened one, if present
			  },
			},
		  },
		  cmake_runner = { -- runner to use
			name = "toggleterm", -- name of the runner
			opts = {}, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
			default_opts = { -- a list of default and possible values for runners
			  toggleterm = {
				direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
				close_on_exit = false, -- whether close the terminal when exit
				auto_scroll = true, -- whether auto scroll to the bottom
				singleton = true, -- single instance, autocloses the opened one, if present
			  },
			},
		  },
		  cmake_notifications = {
			runner = { enabled = false },
			executor = { enabled = false },
			spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
			refresh_rate_ms = 100, -- how often to iterate icons
		  },
		  cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
		  cmake_use_scratch_buffer = false, -- A buffer that shows what cmake-tools has done
		}
		
		local function sync_quickfix_cursor()
		  local qf = vim.fn.getqflist({ idx = 0, winid = 0 })
		  local idx = qf.idx
		  local winid = qf.winid

		  if winid ~= 0 and vim.api.nvim_win_is_valid(winid) and idx and idx > 0 then
			-- put cursor on the current quickfix item
			vim.api.nvim_win_set_cursor(winid, { idx, 0 })
		  end
		end
		
		vim.api.nvim_create_autocmd("QuickFixCmdPost", {
		  pattern = { "cnext", "cprev", "cfirst", "clast", "cc" },
		  callback = sync_quickfix_cursor,
		})
		
		
	end,
}