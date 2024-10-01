---@type NvPluginSpec
-- NOTE: Default Plugins
return {
  -- NvChad Default Terminal
  {
    "NvChad/nvterm",
    enabled = false,
  },

  -- overrides
  { import = "plugins.override.ui" },
}
