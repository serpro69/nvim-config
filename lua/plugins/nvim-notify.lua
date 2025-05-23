---@type NvPluginSpec
-- NOTE: Notification
return {
  "rcarriga/nvim-notify",
  -- lazy = false,
  event = "VeryLazy",
  opts = {
    level = 2,
    minimum_width = 50,
    render = "default",
    stages = "fade_in_slide_out",
    timeout = 3000,
    top_down = false,

    -- make notification window non-focusable
    -- https://github.com/rcarriga/nvim-notify/issues/319#issuecomment-2710287050
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  },
  config = function(_, opts)
    local base46 = require("nvconfig").base46

    if base46.transparency then
      opts.background_colour = "#000000"
    end

    require("notify").setup(opts)

    vim.notify = require "notify"
    local messages = require "core.messages"
    math.randomseed(os.time())
    local randomMessage = messages[math.random(#messages)]
    if vim.g.startup_message then
      vim.notify(randomMessage, vim.log.levels.INFO, { title = "Just For Fun:" })
    end
  end,
}
