return {
  {
    "NvChad/NvChad",
    dev = false,
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },
  { "nvzone/volt" },
  { "nvzone/minty" },
}
