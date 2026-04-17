return
{
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
	
	config=function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED

		vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { silent = true })
		vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { silent = true })

		vim.keymap.set("n", "1", function() harpoon:list():select(1) end, { silent = true })
		vim.keymap.set("n", "2", function() harpoon:list():select(2) end, { silent = true })
		vim.keymap.set("n", "3", function() harpoon:list():select(3) end, { silent = true })
		vim.keymap.set("n", "4", function() harpoon:list():select(4) end, { silent = true })
		vim.keymap.set("n", "5", function() harpoon:list():select(5) end, { silent = true })
		vim.keymap.set("n", "6", function() harpoon:list():select(6) end, { silent = true })
		vim.keymap.set("n", "7", function() harpoon:list():select(7) end, { silent = true })
		vim.keymap.set("n", "8", function() harpoon:list():select(8) end, { silent = true })

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { silent = true })
		vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { silent = true })
	end,
}