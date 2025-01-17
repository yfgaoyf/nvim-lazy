-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false
vim.opt.wildignore = {'*.xml','*.o','*.log'}
vim.opt.completeopt = { "menu", "menuone", "preview", "fuzzy"}
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true

-- fixed clipboard timeout and freezed issue with wezterm
local function no_paste(reg)
    return function(lines)
        -- Do nothing! We can't paste with OSC52
    end
end

vim.g.clipboard = {
    name = "OSC 52",
    copy = {
         ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
         ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = no_paste("+"), -- Pasting disabled
        ["*"] = no_paste("*"), -- Pasting disabled
    }
}
--[[
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}
--]]

-- 设置快捷键
-- inoremap <expr><TAB> pumvisible()?"<C-n>":"<TAB>"

vim.opt.cursorcolumn = true

-- 回车缩进以及tab缩进为4空格
-- Size of an indent
vim.opt.shiftwidth = 4

