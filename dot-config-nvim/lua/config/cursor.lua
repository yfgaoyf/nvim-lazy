local cmd = vim.cmd
cmd([[
    hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
    hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
    ]])


-- 设置光标行/列的颜色
--[[
vim.api.nvim_set_hl(0, "CursorLine", {
  bg = "#ffaa00", -- 将背景色设置为橙色
  fg = "#ffffff", -- 将前景色设置为白色
})

vim.api.nvim_set_hl(0, "CursorColumn", {
  bg = "#ffaa00", -- 将背景色设置为橙色
  fg = "#ffffff", -- 将前景色设置为白色
})
--]]

