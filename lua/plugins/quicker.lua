---@type NvPluginSpec
-- NOTE: Better QuickFixList
return {
  "stevearc/quicker.nvim",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = {},
}
