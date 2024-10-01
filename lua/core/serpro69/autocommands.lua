local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  desc = "Workaround for NvMenu being below NvimTree.",
  pattern = "NvMenu",
  group = augroup("FixNvMenuZindex", { clear = true }),
  callback = function()
    if vim.bo.ft == "NvMenu" then
      vim.api.nvim_win_set_config(0, { zindex = 99 })
    end
  end,
})
