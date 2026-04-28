---@type LazySpec
-- NOTE: Database Grip
return {
  {
    "joryeugene/dadbod-grip.nvim",
    version = "*",
    build = function(plugin)
      local path = plugin.dir .. "/lazy.lua"
      local f = io.open(path, "w")
      if f then
        f:write("return {}\n")
        f:close()
      end
      vim.fn.system({ "git", "-C", plugin.dir, "update-index", "--assume-unchanged", "lazy.lua" })
      os.remove(vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua")
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
