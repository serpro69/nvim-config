---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(...)
  local exists, notify = pcall(require, "notify")
  if exists then
    notify(...)
  else
    print(...)
  end
end
