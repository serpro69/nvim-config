---@type LazySpec
-- NOTE: Live Preview HTML, CSS, JS
return {
  {
    "brianhuster/live-preview.nvim",
    keys = {
      {
        "<leader>blp",
        "<cmd>LivePreview start<cr>",
        desc = "Start Live Preview",
        silent = true,
      },
      {
        "<leader>bls",
        "<cmd>LivePreview start<cr>",
        desc = "Stop Live Preview",
        silent = true,
      },
      {
        "<leader>blP",
        "<cmd>LivePreview pick<cr>",
        desc = "Pick Live Preview",
        silent = true,
      },
    },
    dependencies = {
      "folke/snacks.nvim",
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>bl", group = "Live Preview" },
      },
    },
  },
}
