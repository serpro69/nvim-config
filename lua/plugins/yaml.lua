---@type NvPluginSpec
-- NOTE: Language
return {
  "cuducos/yaml.nvim",
  ft = { "yaml", "yaml.ansible" }, -- optional
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
  },
  init = function()
    -- associate .j2 files with twig to get treesitter support
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { "*.j2" },
      command = "set filetype=twig",
    })
  end,
}
