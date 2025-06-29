require "core.globals"
require "core.env"
require "options"

require "core.serpro69.globals" -- override some globals with my own values
require "serpro69.options" -- add/override vim options
require "serpro69.commands" -- add/override custom vim commands

if vim.version().minor >= 11 then
  vim.tbl_add_reverse_lookup = function(tbl)
    for k, v in pairs(tbl) do
      tbl[v] = k
    end
  end
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.runtimepath:prepend(lazypath)

-- NOTE: lazy.nvim options
local lazy_config = require "core.lazy"

-- Set the |base46_cache| global before initializing plugins (before lazy.setup)
-- :h nvui.base46
-- dofile(vim.g.base46_cache .. "syntax")
-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")
-- load all cache files at once instead of lazyloading them
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

-- NOTE: Load plugins
require("lazy").setup({
  -- {
  --   "NvChad/NvChad",
  --   lazy = false,
  --   branch = "v2.5",
  --   import = "nvchad.plugins",
  -- },

  { import = "serpro69.nvchad" },
  { import = "plugins" },
}, lazy_config)

-- Load themes
-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")

-- Load the highlights
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

require "nvchad.autocmds"
require "core.commands"
require "core.autocommands"
require "core.filetypes"
require "core.utils"
require "mappings"

require "serpro69.mappings"
require "core.serpro69.init"
require "core.serpro69.autocommands"
require "serpro69.notify"
