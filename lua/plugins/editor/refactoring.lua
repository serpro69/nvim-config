---@type LazySpec
-- NOTE: override LazyVim extra config — telescope extension was removed upstream
return {
  {
    "ThePrimeagen/refactoring.nvim",
    config = function(_, opts)
      require("refactoring").setup(opts)
    end,
  },
}
