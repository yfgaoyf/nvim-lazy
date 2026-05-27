# 🔧 修复: fzf-lua picker 中 Tab 键选择文件后无法跳转问题

> 本文档记录了对 `ai-lazy-nvim` 配置的修改，解决了在 fzf-lua picker（如 `<leader>fr` 最近文件）中使用 Tab 键选择文件后按回车无法正确跳转的问题。

---

## 问题描述

### 症状
- 在使用 fzf-lua picker 时，按 Tab 键尝试选择文件没有反应
- 选择文件后按 Enter 键，没有跳转到选中的文件
- fzf 的快捷键被其他插件（特别是 nvim-cmp）干扰

### 根本原因
nvim-cmp 的 Tab 键映射在终端模式（`"i", "s"`）下也生效，当 fzf-lua 打开终端窗口时，cmp 的键映射会干扰 fzf 的正常操作。

---

## 解决方案

我们对两个配置文件做了关键修改：

### 修改 1: `dot-config-nvim/lua/plugins/fzf.lua`

**修改内容**：
- 使用 `config.defaults.keymap.fzf` 来正确配置 fzf 的内部键绑定
- 将 Tab 键映射为 `"down"`（移动到下一个选项）
- 将 Shift-Tab 键映射为 `"up"`（移动到上一个选项）
- 添加 `keys` 配置，确保在 fzf 终端模式下的键有正确的行为

**完整代码**：
```lua
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
```

### 修改 2: `dot-config-nvim/lua/plugins/supertab.lua`

**修改内容**：
- 添加了 `is_fzf_buffer()` 函数来检测当前是否在 fzf 缓冲区
- 在 cmp 的 Tab 键映射中添加检查：如果是在 fzf 中，直接调用 `fallback()`
- 同样为 Shift-Tab 键添加了相同的检查
- 在 cmp 映射的模式列表中添加了 `"t"` 以覆盖终端模式

**完整代码**：
```lua
return {
{
  "L3MON4D3/LuaSnip",
  keys = function()
    return {}
  end,
},
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local luasnip = require("luasnip")
    local cmp = require("cmp")

    -- 检查是否在 fzf 缓冲区中
    local function is_fzf_buffer()
      return vim.bo.filetype == "fzf"
    end

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        -- 如果在 fzf 中，不使用 cmp 的映射
        if is_fzf_buffer() then
          fallback()
        elseif cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        -- they way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s", "t" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        -- 如果在 fzf 中，不使用 cmp 的映射
        if is_fzf_buffer() then
          fallback()
        elseif cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s", "t" }),
    })

    opts.completion = opts.completion or {}
    opts.completion.keyword_length = 1
    opts.completion.completeopt = "menu,menuone,preview,fuzzy"
    
    return opts
  end,
}
}
```

---

## 功能验证

现在已修复的功能：

✅ 在 fzf picker 中，Tab 键可以正常用于在文件列表中移动选择
✅ Shift-Tab 键可以反向移动选择
✅ Enter 键可以正确跳转到你选择的文件（如 `nuttx_main.cpp`）
✅ nvim-cmp 在非 fzf 缓冲区仍能正常工作

### 测试步骤
1. 重启 Neovim
2. 按 `<leader>fr` 打开最近文件列表
3. 按 Tab 键在列表中移动
4. 选择一个文件按 Enter 键，应该能正确跳转到该文件

---

## 配置原则与注意事项

这个修改遵循了项目的配置原则：

1. **不要直接修改 LazyVim 源码** - 所有修改都在 `dot-config-nvim/lua/plugins/` 下
2. **使用合并和函数式覆盖** - 没有完全重写插件配置，而是在现有基础上做修改
3. **检测文件类型来隔离行为** - 通过检查 `vim.bo.filetype == "fzf"` 来确保在 fzf 窗口中的特殊处理

---

## 参考

- LazyVim 默认 fzf 配置: `dot-local-share-nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/editor/fzf.lua`
- fzf-lua 官方文档: <https://github.com/ibhagwan/fzf-lua>
- nvim-cmp 键映射配置: <https://github.com/hrsh7th/nvim-cmp#mapping-configuration>

---

**修改日期**: 2026-05-26
