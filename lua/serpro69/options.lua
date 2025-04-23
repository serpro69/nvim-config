-- NOTE: Neovim options

local options = {}

vim.opt.shortmess:append "q" -- do not show "recording @a" when recording a macro	*shm-q*

for name, value in pairs(options) do
  vim.opt[name] = value
end
