return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
	"williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import mason_lspconfig plugin
        local mason_lspconfig = require("mason-lspconfig")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)			
				require("vim-keymaps-debug").MapLspKeys(ev)
            end,
        })

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end
		
        --lspconfig.lua_ls.setup({
        --capabilities = capabilities
      	--})
		
	local navic = require("nvim-navic")
		
	vim.lsp.config("lua_ls", {
		capabilities = capabilities,
	})
	vim.lsp.enable("clangd")

	vim.lsp.config("clangd", {
		capabilities = capabilities,
	})
	vim.lsp.enable("clangd")
	
	vim.lsp.config("pyright", {
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			navic.attach(client, bufnr)
		end
	})
	vim.lsp.enable("pyright")

	
	vim.lsp.config.ruff_lsp = {
	  cmd = { "ruff-lsp" },
	  filetypes = { "python" },
	  root_markers = { "pyproject.toml", ".git" },
	}

	vim.lsp.enable("ruff_lsp")
	
	vim.lsp.config("qmlls", {
	  cmd = { "qmlls", "-E" },
	  filetypes = { "qml", "qmljs" },
	})
	vim.lsp.enable("qmlls")

	
	--lspconfig.clangd.setup(
	--	{
	--	cmd={"clangd", "--background-index", "--compile-commands-dir=.", 
	--					"--function-arg-placeholders=0","--pch-storage=memory", },
    --    capabilities = capabilities
    --  	})
	

	-- do error check after a small pause after typing in insert mode
	local IDLE_MS = 750

	local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
	local pending, timers = {}, {}

	vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
	  if not result or not result.uri then
		return orig(err, result, ctx, config)
	  end

	  local bufnr = vim.uri_to_bufnr(result.uri)

	  -- If we're in insert mode, debounce; otherwise forward immediately
	  if vim.fn.mode() == "i" then
		pending[bufnr] = { err = err, result = result, ctx = ctx, config = config }

		if timers[bufnr] then
		  timers[bufnr]:stop(); timers[bufnr]:close()
		end

		local t = vim.loop.new_timer()
		timers[bufnr] = t
		t:start(IDLE_MS, 0, function()
		  vim.schedule(function()
			local p = pending[bufnr]
			if p then
			  orig(p.err, p.result, p.ctx, p.config)
			  pending[bufnr] = nil
			end
		  end)
		end)
	  else
		-- Not in insert mode: show right away
		if timers[bufnr] then timers[bufnr]:stop(); timers[bufnr]:close(); timers[bufnr] = nil end
		pending[bufnr] = nil
		return orig(err, result, ctx, config)
	  end
	end

	vim.diagnostic.config({
	  update_in_insert = true,   -- show diagnostics in insert mode
	})	
	
		

	local ok, cmp = pcall(require, "cmp")
	if ok then
	  cmp.setup({
		window = {
		  documentation = cmp.config.disable,  -- hide docs popup in completion menu
		},
	  })
	end

    end
	
	
}
