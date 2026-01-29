return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,	  -- (lua)  formatting
        null_ls.builtins.formatting.prettier, -- (json/yaml)  formatting
		null_ls.builtins.diagnostics.mypy, -- (python)  type checking
		--null_ls.builtins.diagnostics.ruff, -- (python)  linting
        null_ls.builtins.formatting.black, -- (python)  formatting
      },
    })
  end,
}
