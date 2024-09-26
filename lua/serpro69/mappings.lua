-- NOTE: My personal mappings in a separate file for easier upstream syncing

-- General

vim.keymap.set("i", "jj", "<ESC>", { desc = "General | Exit Insert Mode" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "General | Exit Insert Mode" })
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "General | Save Buffer", silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "General | Clear Search Highlights" })
vim.keymap.set("n", "<leader>cs", "<cmd><CR>", { desc = "General | Clear Statusline" })
