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

-- -- Set cursor position for nvdash
-- -- credits to @gale ( https://discord.com/channels/869557815780470834/869557816430563370/1287435062769356830 )
-- autocmd("FileType", {
--   pattern = "nvdash",
--   callback = function()
--     if vim.bo.ft == "nvdash" then
--       vim.api.nvim_win_set_cursor(0, { 18, 52 })
--     end
--   end,
-- })
