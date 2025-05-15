---@type NvPluginSpec
-- NOTE: Pomodoro in Neovim
return {
  "epwalsh/pomo.nvim",
  version = "*",
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    "rcarriga/nvim-notify",
  },
  opts = {
    sessions = {
      pomodoro = {
        { name = "Work", duration = "50m" },
        { name = "Short Break", duration = "10m" },
        { name = "Work", duration = "50m" },
        { name = "Short Break", duration = "10m" },
        { name = "Work", duration = "50m" },
        { name = "Short Break", duration = "10m" },
        { name = "Work", duration = "50m" },
        { name = "Long Break", duration = "30m" },
      },
    },
  },
}
