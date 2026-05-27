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

