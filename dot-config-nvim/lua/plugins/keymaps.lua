-- 自定义按键映射覆盖
return {
  {
    "ibhagwan/fzf-lua",
    optional = true,
    keys = {
      {
        "<leader>fr",
        function()
          require("fzf-lua").oldfiles({ cwd_only = true, stat_file = true })
        end,
        desc = "Recent (cwd)",
      },
    },
  },
}

