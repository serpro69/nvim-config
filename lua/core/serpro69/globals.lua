-- NOTE: Global Variables

local global = {
  disable_autoformat = false,
}

for name, value in pairs(global) do
  vim.g[name] = value
end
