return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      local config = require("fzf-lua.config")
      
      -- 使用 config 来配置键映射
      config.defaults.keymap.fzf = config.defaults.keymap.fzf or {}
      config.defaults.keymap.fzf["tab"] = "down"
      config.defaults.keymap.fzf["btab"] = "up"
      
      opts.fzf_opts = opts.fzf_opts or {}
      opts.fzf_opts["--cycle"] = true
      
      opts.files = opts.files or {}
      opts.files.fd_opts = [[--color=never --type f --hidden --no-ignore --follow -E .git -E .cache -E .repo -E prebuilts -E "*.o" -E "*.png" -E "*.d"]]
      opts.grep = opts.grep or {}
      opts.grep.rg_opts = [[--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore -g "!.git" -g "!.cache" -g "!.repo" -g "!prebuilts" -g "!*.o" -g "!*.png" -g "!*.d"]]
      
      -- 配置 oldfiles 只显示当前工作目录的文件，过滤掉不存在的文件
      opts.oldfiles = opts.oldfiles or {}
      opts.oldfiles.cwd_only = true
      opts.oldfiles.stat_file = true
      opts.oldfiles.sort_lastused = true
      
      return opts
    end,
    keys = {
      -- 确保在 fzf 终端模式下的 Tab 和 Enter 键不会被其他插件干扰
      { "<Tab>", "<Tab>", ft = "fzf", mode = "t", nowait = true, noremap = true },
      { "<S-Tab>", "<S-Tab>", ft = "fzf", mode = "t", nowait = true, noremap = true },
      { "<CR>", "<CR>", ft = "fzf", mode = "t", nowait = true, noremap = true },
    },
  },
}
