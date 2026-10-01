---@type LazySpec
-- NOTE: QoL Plugins
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = function(_, opts)
    if vim.env.TMUX then
      -- Markdown previews probe the terminal even when image support wasn't enabled.
      -- With tmux extended-keys=always, replies can leak as keys and switch pickers.
      -- TODO: Re-enable images in tmux when Snacks handles "always" as well as "on".
      -- https://github.com/folke/snacks.nvim/issues/2332
      opts.image = opts.image or {}
      opts.image.enabled = false
    end
  end,
  keys = {
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
  },
}
