-- NOTE: My personal mappings in a separate file for easier upstream syncing

--- General

vim.keymap.set("i", "jj", "<ESC>", { desc = "General | Exit Insert Mode" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "General | Exit Insert Mode" })
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "General | Save Buffer", silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "General | Clear Search Highlights" })

-- NOTE: <leader>b for Buffer-related mappings
--
-- delete original <leader>c for closing the buffer
vim.keymap.del("n", "<leader>c")
-- and set it to <leader>bc
vim.keymap.set("n", "<leader>bc", "<cmd>Bdelete!<cr>", { desc = "General | Close Buffer", silent = true })
-- set <leader>bd to close all buffers but the current one
-- credits: https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one
vim.keymap.set(
  "n",
  "<leader>bd",
  "<cmd>%bd|e#|bd#<cr>|'\"",
  { desc = "General | Close All Buffers but Current", silent = true }
)

vim.keymap.set("n", "<leader>cs", "<cmd><CR>", { desc = "General | Clear Statusline" })
