# 修复 fzf-lua Tab 键循环选择问题

## 日期
2026-05-26

## 问题描述
使用 `<leader>fr` 打开最近文件列表后，按 Tab 键选择文件时无法循环滚动，到达最后一个文件后不能回到第一个文件。

## 解决方案

### 修改文件
`/home/gaoyf/ai-lazy-nvim/dot-config-nvim/lua/plugins/fzf.lua`

### 完整配置

```lua
return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      -- 启用循环选择 (核心修复)
      opts.fzf_opts = opts.fzf_opts or {}
      opts.fzf_opts["--cycle"] = true
      
      -- 文件搜索配置
      opts.files = opts.files or {}
      opts.files.fd_opts = [[--color=never --type f --hidden --no-ignore --follow -E .git -E .cache -E .repo -E prebuilts -E "*.o" -E "*.png" -E "*.d"]]
      
      -- Grep 搜索配置
      opts.grep = opts.grep or {}
      opts.grep.rg_opts = [[--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore -g "!.git" -g "!.cache" -g "!.repo" -g "!prebuilts" -g "!*.o" -g "!*.png" -g "!*.d"]]
      
      return opts
    end,
  },
}
```

## 核心修改

### 1. 关键配置项
```lua
opts.fzf_opts = opts.fzf_opts or {}
opts.fzf_opts["--cycle"] = true
```

### 2. 说明
- `--cycle` 选项启用 fzf 的循环滚动功能
- 适用于所有 fzf-lua picker，包括 oldfiles、files、grep 等
- 按下 Tab 键向下选择，到达最后一项后自动回到第一项
- 按下 Shift+Tab 键向上选择，到达第一项后自动回到最后一项

## 功能说明

### 修复的功能
- ✅ `<leader>fr` (最近文件) 支持 Tab 循环选择
- ✅ 所有其他 fzf-lua picker 同样支持循环选择
- ✅ 保留原有的文件过滤配置

### 涉及的快捷键
- `<leader>fr` - 打开最近文件列表
- `Tab` - 向下选择（循环）
- `Shift+Tab` - 向上选择（循环）

## 相关文件
- 修改文件：`/home/gaoyf/ai-lazy-nvim/dot-config-nvim/lua/plugins/fzf.lua`
- 参考文件：`/home/gaoyf/ai-lazy-nvim/dot-local-share-nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/editor/fzf.lua`

## 验证
重启 Neovim 后，使用 `<leader>fr` 打开最近文件列表，尝试按 Tab 键多次，应能看到循环选择效果。
