---@module 'lazy'
---@type LazySpec
return {
  "L3MON4D3/LuaSnip",
  keys = {
    {
      "<C-n>",
      "<Plug>luasnip-next-choice",
      silent = true,
      mode = { "i", "s" },
    },
    {
      "<C-p>",
      "<Plug>luasnip-prev-choice",
      silent = true,
      mode = { "i", "s" },
    },
    {
      "<M-e>",
      function()
        if require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        end
      end,
      silent = true,
      mode = { "i", "s" },
      noremap = true,
    },
    {
      "<M-c>",
      function()
        if require("luasnip").choice_active() then
          require("luasnip.extras.select_choice")()
        end
      end,
      silent = true,
      mode = { "i", "s" },
    },
  },
}
