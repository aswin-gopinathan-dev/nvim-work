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
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local navic = require("nvim-navic")

        -- 1. Global Diagnostic Configuration (Replaces manual sign loops)
        vim.diagnostic.config({
            underline = true,
            update_in_insert = true, -- Replaces your custom insert mode logic
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN]  = " ",
                    [vim.diagnostic.severity.HINT]  = "󰠠 ",
                    [vim.diagnostic.severity.INFO]  = " ",
                },
            },
        })

        -- 2. Global LspAttach for Shared Logic
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                
                -- Attach Navic globally if server supports symbols
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, ev.buf)
                end
                
                -- Map custom keys from your external module
                require("vim-keymaps-debug").MapLspKeys(ev)
            end,
        })

        -- 3. Native LSP Configurations
        -- Define global defaults for all servers
        vim.lsp.config('*', { capabilities = capabilities })

        -- Enable specific servers
        -- Note: 'ruff_lsp' is deprecated; Nvim 0.11 uses 'ruff' natively
        local servers = { "lua_ls", "clangd", "pyright", "ruff", "qmlls" }
        
        -- Custom command for qmlls if needed
        vim.lsp.config("qmlls", { cmd = { "qmlls", "-E" } })

        -- Activate all servers
        vim.lsp.enable(servers)

        -- 4. Completion UI Tweaks (Keep if you prefer nvim-cmp)
        local ok, cmp = pcall(require, "cmp")
        if ok then
            cmp.setup({
                window = {
                    documentation = cmp.config.disable,
                },
            })
        end
    end
}