return {
    'akinsho/toggleterm.nvim',
    config = function()
		vim.o.shell = "pwsh"
        vim.o.shellcmdflag = "-NoLogo -NoProfile -Command"
        --vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
		--vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
		--vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s"
		--vim.o.shellquote = ""
		vim.o.shellxquote = ""

        local term = require("toggleterm")
        term.setup({
            size = 9,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 3,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "horizontal",
            close_on_exit = true,
            --shell = vim.o.shell,
            shell = "pwsh -NoLogo -NoProfile",

            float_opts = {
                border = "curved",
				col=8,
				row=2,
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        })        

    end,
}
