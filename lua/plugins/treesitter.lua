return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- import nvim-treesitter plugin
        local ok, treesitter = pcall(require, "nvim-treesitter.configs")
        if not ok then
            treesitter = require("nvim-treesitter.config")
        end
        
        local install = require("nvim-treesitter.install")
        if vim.fn.executable("zig") == 1 then
          install.compilers = { "zig" }
        elseif vim.fn.executable("clang") == 1 then
          install.compilers = { "clang" }
        elseif vim.fn.executable("gcc") == 1 then
          install.compilers = { "gcc" }
        end

        -- configure treesitter
        treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
                enable = true,
            },
            -- ensure these language parsers are installed
            ensure_installed = {
                "cpp",
                "lua",
                "qmljs",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
