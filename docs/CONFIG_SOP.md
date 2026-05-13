# 📘 SOP:在 `ai-lazy-nvim` 中编写配置覆盖默认设置

> 本文档面向希望在 `ai-lazy-nvim`(LazyVim 发行版)基础上进行个性化定制的用户。所有"用户自定义"都发生在 `dot-config-nvim/lua/` 目录下,安装后对应本机路径 `~/.config/nvim/lua/`。

---

## 目录

- [1. 前置原则(必读)](#1-前置原则必读)
- [2. 目录职责一览](#2-目录职责一览)
- [3. 三大场景 SOP](#3-三大场景-sop)
  - [场景 A:修改 Vim 选项 / 键位 / 自动命令](#-场景-a修改-vim-选项--键位--自动命令)
  - [场景 B:覆盖 LazyVim 内置插件的配置](#-场景-b覆盖-lazyvim-内置插件的配置)
  - [场景 C:新增 / 禁用 / 切换插件](#-场景-c新增--禁用--切换插件)
- [4. 标准操作流程(Checklist)](#4-标准操作流程checklist)
- [5. 常见坑与排查](#5-常见坑与排查)
- [6. 快速模板速查](#6-快速模板速查)
- [7. 参考链接](#7-参考链接)

---

## 1. 前置原则(必读)

在动手之前,请牢记以下 5 条黄金法则:

| #   | 原则                                              | 说明                                                                                           |
| --- | ------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| 1   | **不要直接修改 LazyVim 源码**                      | 即不要去动 `~/.local/share/nvim/lazy/LazyVim/` 里的任何文件,否则插件更新会冲突或覆盖。        |
| 2   | **所有覆盖都放在 `lua/config/` 或 `lua/plugins/` 下** | 这是 LazyVim 的约定俗成入口,会被 `lua/config/lazy.lua` 自动加载。                               |
| 3   | **每个自定义文件必须 `return` 一个表**             | `lua/plugins/*.lua` 的规范是返回一个 plugin spec(或 spec 列表)。                              |
| 4   | **文件名即加载依据**                               | `lua/plugins/` 下的所有 `.lua` 文件会被自动 `import`;`neo-tree.luaa` 这种非 `.lua` 后缀会被忽略(项目里用作"禁用"技巧)。 |
| 5   | **配置修改后需重启或 `:Lazy sync`**                | 插件 spec 级改动需 `:Lazy sync` / `:Lazy reload`;`options/keymaps/autocmds` 改动重启 Neovim 即可。 |

---

## 2. 目录职责一览

```
dot-config-nvim/lua/
├── config/                 # 纯配置:选项、键位、自动命令、自定义高亮等
│   ├── lazy.lua            # Lazy.nvim 启动入口(一般不改)
│   ├── options.lua         # vim.opt / vim.g 级别的全局选项
│   ├── keymaps.lua         # 全局键位映射
│   ├── autocmds.lua        # 自动命令
│   ├── cursor.lua          # 光标行/列高亮(项目自定义)
│   └── highlights.lua      # 自定义高亮工具(项目自定义)
│
└── plugins/                # 插件级配置(新增、覆盖、禁用)
    ├── example.lua         # LazyVim 官方示例(`if true then return {} end`,不生效,仅参考)
    ├── supertab.lua        # 覆盖 nvim-cmp + LuaSnip(实现 Tab 补全)
    ├── docs-view.lua       # 新增 nvim-docs-view 插件
    ├── neo-tree.luaa       # 文件扩展名非 .lua,故意禁用(样例)
    ├── gentags_plugin/     # 本地插件源码目录
    └── plenary_plugin/     # 本地插件源码目录
```

---

## 3. 三大场景 SOP

LazyVim 的配置哲学本质只有三件事:**修改选项/键位**、**覆盖/扩展插件**、**新增/禁用插件**。

### 🟢 场景 A:修改 Vim 选项 / 键位 / 自动命令

适用:`vim.opt.tabstop = 4`、新增一条 `map`、写一个 `autocmd` 等。

**步骤**:

1. 打开对应的文件:
   - 选项 → `lua/config/options.lua`
   - 键位 → `lua/config/keymaps.lua`
   - 自动命令 → `lua/config/autocmds.lua`
2. 在文件末尾**追加**自己的配置(不要删除顶部注释,它提示了 LazyVim 默认值出处)。
3. 保存 → 重启 Neovim。

**示例(追加到 `options.lua`)**:

```lua
-- 我希望 tab 宽度为 2,并显示相对行号
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
```

**示例(追加到 `keymaps.lua`)**:

```lua
local map = vim.keymap.set
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })
```

> ⚠️ LazyVim 的默认键位见 `~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/config/keymaps.lua`,不要改那里,在 `keymaps.lua` 里重新映射同一键位即可覆盖。

---

### 🟡 场景 B:覆盖 LazyVim 内置插件的配置

适用:修改某个已被 LazyVim 引入的插件(如 `nvim-cmp`、`trouble.nvim`、`neo-tree.nvim`)的 opts。

**步骤**:

1. 在 `lua/plugins/` 下**新建**一个 `.lua` 文件(文件名自取,建议用插件名)。
2. `return` 一个表,表中每一项是 `{ "<仓库名>", opts = ... }` 形式的 spec。
3. LazyVim 会把你的 `opts` 与默认 opts **深度合并**(除非用函数形式完全覆盖)。

**三种覆盖方式**:

| 方式               | 写法                                                                 | 效果                          |
| ------------------ | -------------------------------------------------------------------- | ----------------------------- |
| 合并式(推荐)      | `opts = { use_diagnostic_signs = true }`                             | 与默认 opts 合并              |
| 函数式(精细控制)  | `opts = function(_, opts) table.insert(opts.sources, {...}) end`      | 拿到默认 opts 手动改          |
| 完全重写           | `config = function() require("xxx").setup({...}) end`                | 丢弃默认,按自己的 setup 跑   |

**示例 1:合并式(新建 `lua/plugins/trouble.lua`)**

```lua
return {
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
}
```

**示例 2:函数式(参考本项目 `lua/plugins/supertab.lua`)**

```lua
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = require("cmp").mapping.select_next_item(),
      })
    end,
  },
}
```

**示例 3:完全重写(参考本项目 `lua/plugins/neo-tree.luaa`)**

```lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          never_show_by_pattern = { "*.log", "*.xml" },
        },
      },
    })
  end,
}
```

---

### 🔵 场景 C:新增 / 禁用 / 切换插件

#### C-1 新增一个插件

以新增 `nvim-docs-view` 为例:

```lua
-- lua/plugins/docs-view.lua
return {
  "amrbashir/nvim-docs-view",
  lazy = true,
  cmd = "DocsViewToggle",   -- 仅在执行该命令时加载
  opts = {
    position = "right",
    width = 60,
  },
}
```

常见懒加载触发器:`cmd`、`event`、`keys`、`ft`、`lazy = true`。

#### C-2 禁用 LazyVim 自带的插件

```lua
-- lua/plugins/disable.lua
return {
  { "folke/trouble.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
}
```

#### C-3 切换主题 / colorscheme

```lua
-- lua/plugins/colorscheme.lua
return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox" },
  },
}
```

#### C-4 启用 LazyVim Extras(推荐的"一键扩展"方式)

LazyVim 提供大量 Extras(如 `lang.rust`、`dap.core`、`coding.copilot`)。

- **GUI 方式**:在 Neovim 内执行 `:LazyExtras`,选中回车即可,会写入 `dot-config-nvim/lazyvim.json` 的 `extras` 字段。
- **手动方式**:直接编辑 `lazyvim.json`:

  ```json
  {
    "extras": [
      "lazyvim.plugins.extras.lang.rust",
      "lazyvim.plugins.extras.dap.core"
    ],
    "version": 6
  }
  ```

---

## 4. 标准操作流程(Checklist)

每次想做配置变更,按以下顺序执行即可:

```
┌─────────────────────────────────────────────────────────┐
│ 1. 明确需求属于哪个场景(A/B/C)                         │
│ 2. 定位文件:                                             │
│     - 场景 A → lua/config/{options|keymaps|autocmds}.lua │
│     - 场景 B/C → 在 lua/plugins/ 下新建 *.lua            │
│ 3. 编写 return { ... } spec(仅 plugins/ 目录需要)       │
│ 4. 保存文件                                              │
│ 5. 重启 Neovim 或 :Lazy reload <plugin>                  │
│ 6. 验证:                                                 │
│     :Lazy         查看插件状态                           │
│     :checkhealth  检查健康                               │
│     :LspInfo      LSP 状态                               │
│ 7. 如有问题:                                             │
│     :messages     查看报错                               │
│     :Lazy log     查看插件加载日志                       │
│ 8. 稳定后可选:提交到 Git(本项目是 Git 管理的)          │
└─────────────────────────────────────────────────────────┘
```

---

## 5. 常见坑与排查

| 症状                                        | 可能原因                                      | 解决                                                                                               |
| ------------------------------------------- | --------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| 新建的 plugin 文件没生效                    | 文件名不是 `.lua` 后缀(如 `foo.luaa`)        | 改回 `.lua`                                                                                        |
| `opts` 没合并,全量丢失                      | 同时写了 `config = function()` 又写了 `opts`  | 二选一;用 `config` 时需自己合并                                                                   |
| 键位被 LazyVim 默认覆盖                      | LazyVim 在 `VeryLazy` 事件后才加载 keymaps    | 在 `keymaps.lua` 里重新 `vim.keymap.set` 即可                                                       |
| `:Lazy` 看到 `has local changes`            | 改了 `~/.local/share/nvim/lazy/` 下源码       | 用 `tools/find-changes.sh` 扫描,回退后改到 `dot-config-nvim/lua/plugins/` 里                       |
| Mason 工具不可用                            | 软链失效                                      | 重跑 `tools/update-mason-bin-link.sh`                                                              |
| `clangd` 找不到                             | Git LFS 未拉取                                | `git lfs install && git lfs pull`                                                                  |

---

## 6. 快速模板速查

复制即用的模板,直接粘到新文件里改名即可。

**① 新增插件模板** → `lua/plugins/<name>.lua`

```lua
return {
  "<github-user>/<plugin-repo>",
  event = "VeryLazy",
  opts = {
    -- your options
  },
}
```

**② 覆盖已有插件 opts 模板**

```lua
return {
  {
    "<github-user>/<plugin-repo>",
    opts = function(_, opts)
      opts.xxx = "value"
      return opts
    end,
  },
}
```

**③ 禁用插件模板**

```lua
return {
  { "<github-user>/<plugin-repo>", enabled = false },
}
```

**④ 新增键位模板** → 追加到 `lua/config/keymaps.lua`

```lua
vim.keymap.set("n", "<leader>xx", function() print("hi") end, { desc = "Demo" })
```

---

## 7. 参考链接

- LazyVim 官方配置指南:<https://www.lazyvim.org/configuration>
- LazyVim Plugin Spec:<https://www.lazyvim.org/configuration/plugins>
- Lazy.nvim(插件管理器):<https://lazy.folke.io/>
- 本项目示例文件 `dot-config-nvim/lua/plugins/example.lua` 几乎涵盖所有场景,**强烈建议精读一遍**。

---

## 附:把本机改动同步回仓库

本机调试稳定后,可用以下命令把 `~/.config/nvim` 同步回仓库目录便于 Git 管理:

```bash
cp -rf ~/.config/nvim/. dot-config-nvim/
git -C /path/to/ai-lazy-nvim diff dot-config-nvim/
```
