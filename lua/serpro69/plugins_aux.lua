-- NOTE: plugin extras
local M = {}

M.ai_models = {
  claude = {
    sonnet_3_5 = "claude-3.5-sonnet",
    sonnet_3_7 = "claude-3.7-sonnet",
  },
  -- https://ai.google.dev/gemini-api/docs/models
  gemini = {
    flash = "gemini-2.5-flash-preview-04-17",
    pro = "gemini-2.5-pro-preview-05-06",
  },
}

M.keymaps = {
  nvim_tree = function(opts)
    local api = require "nvim-tree.api"

    -- Add file/folder to avante
    -- Based on https://github.com/yetone/avante.nvim?tab=readme-ov-file#neotree-shortcut
    vim.keymap.set("n", "oa", function()
      local node = api.tree.get_node_under_cursor()
      if not node then
        return
      end

      local filepath = node.absolute_path
      local relative_path = require("avante.utils").relative_path(filepath)

      local sidebar = require("avante").get()

      local open = sidebar:is_open()
      -- ensure avante sidebar is open
      if not open then
        require("avante.api").ask()
        sidebar = require("avante").get()
      end

      sidebar.file_selector:add_selected_file(relative_path)

      -- remove nvim-tree buffer if it wasn't open before
      if not open then
        sidebar.file_selector:remove_selected_file "NvimTree_1"
      end
    end, opts "Add to Avante Selected Files")
  end,
}

return M
