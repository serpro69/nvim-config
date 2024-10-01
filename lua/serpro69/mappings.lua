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

--- Options

-- NvChad
vim.keymap.set("n", "<leader>ont", function()
  require("nvchad.themes").open { style = "flat" }
end, { desc = "NvChad | Open Theme Selector" })

--NvMenu
local serpro_menu = {
  {
    name = "  Lsp Actions",
    hl = "Exblue",
    items = "lsp",
  },
  { name = "separator" },
  {
    name = "  Color Picker",
    hl = "Exred",
    cmd = function()
      require("minty.huefy").open()
    end,
  },
}

vim.keymap.set("n", "<leader>onm", function()
  require("menu").open(serpro_menu)
end, { desc = "NvChad | Open Menu" })

vim.keymap.set("n", "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'
  local options = vim.bo.ft == "NvimTree" and "nvimtree" or serpro_menu
  require("menu").open(options, { mouse = true })
end, { desc = "NvChad | Open Menu" })
