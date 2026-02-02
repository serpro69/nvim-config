require("config.lazy")
require("config.commands")
require("config.filetypes")
require("config.utils")

if vim.g.vscode then
  vim.opt.shortmess:append("s")
  vim.opt.cmdheight = 1
end

-- Late overrides (after plugins load): keymaps, autocmds, etc.
pcall(require, "config.overrides")
