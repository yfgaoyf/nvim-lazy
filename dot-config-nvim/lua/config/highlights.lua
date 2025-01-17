local highlights = {}

vim.cmd([[
    highlight SourceInsight ctermfg=white ctermbg=Magenta guibg=Magenta guifg=White
]])

local function doHighlightEnable(word)
    if highlights[word] == nil then
        local hl_id = vim.fn.matchadd("SourceInsight", word)
        highlights[word] = hl_id
    end
end

local function highlightEnable()
    vim.ui.input({ prompt = "input a word to highlight" }, function(word)
        if word == nil or word == "" then
            return
        end

        doHighlightEnable(word)
    end)
end

local function doHighlightDismiss(word)
    if highlights[word] ~= nil then
        vim.fn.matchdelete(highlights[word])
        highlights[word] = nil
    end
end

local function extract_keys(tbl)
    local keys = {}

    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end

    return keys
end

local function highlightDismiss()
    local keys = extract_keys(highlights)

    if next(keys) == nil then
        return
    end

    vim.ui.select(keys, {
        prompt = "select hightlight to dismiss",
        format_item = function(word)
            return word
        end,
    }, function (choice)
            if choice then
                doHighlightDismiss(choice)
            end
        end)
end

local function highlightDismissAll()
    for key, _ in pairs(highlights) do
        doHighlightDismiss(key)
    end
end

local function highlightToggle()
    local word
    local visual = vim.fn.mode() == "v"

    if visual == true then
        local saved_reg = vim.fn.getreg "v"
        vim.cmd [[noautocmd sil norm "vy]]
        local sele = vim.fn.getreg "v"
        vim.fn.setreg("v", saved_reg)
        word = sele
    else
        word = vim.fn.expand "<cword>"
    end

    if highlights[word] == nil then
        doHighlightEnable(word)
    else
        doHighlightDismiss(word)
    end
end

local wk = require("which-key")
wk.register({
    ["<leader>h"] = {
        mode = { "n", "v" },
        name = "+highlight",
        t = { function() highlightToggle() end, "toggle highlight" },
        e = { function() highlightEnable() end, "enable highlight" },
        d = { function() highlightDismiss() end, "dismiss highlight" },
        D = { function() highlightDismissAll() end, "dismiss all highlight" },
    },
})

vim.api.nvim_create_user_command("HlToggle", function() highlightToggle() end, {})
vim.api.nvim_create_user_command("HlEnable", function() highlightEnable() end, {})
vim.api.nvim_create_user_command("HlDismiss", function() highlightDismiss() end, {})
vim.api.nvim_create_user_command("HlDismissAll", function() highlightDismissAll() end, {})
