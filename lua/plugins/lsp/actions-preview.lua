---@type LazySpec
-- NOTE: LSP Actions Preview
return {
  "aznhe21/actions-preview.nvim",
  enabled = true,
  event = "LspAttach",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  init = function() end,
  config = function()
    require("actions-preview").setup({
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
    })
  end,
}
