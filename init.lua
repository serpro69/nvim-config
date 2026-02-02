require("config.lazy")
require("config.commands")
require("config.filetypes")
require("config.utils")

-- Late overrides (after plugins load): keymaps, autocmds, etc.
pcall(require, "config.overrides")
