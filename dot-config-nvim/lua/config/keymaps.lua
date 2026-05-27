-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- local remap = vim.api.nvim_set_keymap
-- vim.api.nvim_set_keymap("i", "<expr><TAB>", 'pumvisible() ? "<C-n>" : "<TAB>"', opts)
-- remap('i', '<tab>', [[pumvisible() ? "<C-n>" : "<C-n>"]], { expr = true, noremap = true })
-- remap('i', '<s-tab>', [[pumvisible() ? "<C-p>" : "<C-p>"]], { expr = true, noremap = true })

vim.keymap.set("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Ctrl+Click go to definition" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Incoming Calls" })
vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Outgoing Calls" })
