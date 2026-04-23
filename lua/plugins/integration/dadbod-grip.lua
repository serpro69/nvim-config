---@type LazySpec
-- NOTE: Database Grip
return {
  {
    "joryeugene/dadbod-grip.nvim",
    version = "*",
    -- plugin's lazy.lua is incompatible with lazy.nvim pkg system
    build = function(plugin)
      os.remove(plugin.dir .. "/lazy.lua")
    end,
    opts = {
      completion = false,
      keymaps = { qpad_execute = "<CR>" },
    },
    cmd = {
      "Grip",
      "GripStart",
      "GripHome",
      "GripConnect",
      "GripSchema",
      "GripTables",
      "GripQuery",
      "GripSave",
      "GripLoad",
      "GripHistory",
      "GripProfile",
      "GripExplain",
      "GripAsk",
      "GripDiff",
      "GripCreate",
      "GripDrop",
      "GripRename",
      "GripProperties",
      "GripExport",
      "GripAttach",
      "GripDetach",
      "GripOpen",
    },
    keys = {
      { "<leader>D", false },
      {
        "<leader>D",
        "<cmd>GripConnect<cr>",
        desc = "DBGrip: Connect",
        silent = true,
      },
    },
  },
}
