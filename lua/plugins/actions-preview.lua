---@type NvPluginSpec
-- NOTE: LSP Actions
return {
  "aznhe21/actions-preview.nvim",
  init = function()
    vim.keymap.set({ "v", "n" }, "<leader>lc", require("actions-preview").code_actions, { desc = "LSP | Code action" })
  end,
  config = function()
    require("actions-preview").setup {
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    }
  end,
  event = "LspAttach",
}
