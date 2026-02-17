return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  config = function()
    require("marks").setup({
      default_mappings = false, -- we’ll define our own keys
      bookmark_0 = {
        sign = "",
        virt_text = "",
        annotate = false,
      },
    })
  end,
}
