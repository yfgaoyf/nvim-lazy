return {
  "ldelossa/litee-calltree.nvim",
  dependencies = { "ldelossa/litee.nvim" },
  event = "VeryLazy",
  config = function()
    require("litee.lib").setup()
    require("litee.calltree").setup({})
  end,
}
