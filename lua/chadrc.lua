-- ref: https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- NOTE: NvChad Related Options
---@type ChadrcConfig
-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(
local M = {}

local highlights = require "highlights"
local headers = require "core.statusline.headers"

local function get_header(default)
  if vim.g.random_header then
    local headerNames = {}
    for name, _ in pairs(headers) do
      table.insert(headerNames, name)
    end

    local randomName = headerNames[math.random(#headerNames)]
    local randomHeader = headers[randomName]
    return randomHeader
  else
    local name = (default == nil or default == "") and "nvchad" or default
    return headers[name]
  end
end

M.ui = {
  telescope = { style = "borderless" }, -- borderless / bordered
  cmp = {
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      tailwind = true,
    },
  },
  statusline = {
    theme = "minimal", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "round",
    order = {
      "mode",
      "file",
      "git",
      "%=",
      "pomo_timer",
      "lsp_msg",
      "python_venv",
      "diagnostics",
      "command",
      "clients",
      "cwd",
      "total_lines",
    },
    modules = vim.tbl_deep_extend("force", require("core.statusline").modules, require("serpro69.chadrc_aux").modules),
  },

  tabufline = {
    enabled = true,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = require("core.tabufline").modules,
  },
}

M.nvdash = {
  load_on_startup = true,
  header = get_header "nvchad",
  buttons = {
    { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
    { txt = "󰈚  Recent Files", keys = "Spc f r", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
    { txt = "  Find Projects", keys = "Spc f p", cmd = "Telescope projects" },
    { txt = "  Themes", keys = "Spc f t", cmd = "Telescope themes" },
    { txt = "  Mappings", keys = "Spc n c", cmd = "NvCheatsheet" },
    { txt = "─", no_gap = true, rep = true },
    {
      txt = function()
        local stats = require("lazy").stats()
        local milliseconds = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. milliseconds
      end,
      no_gap = true,
    },
    { txt = "─", no_gap = true, rep = true },
  },
}

-- Override some Nvdash defaults
M.nvdash.load_on_startup = false
-- own header
M.nvdash.header = get_header "wlcm3"
-- extra buttons
local extraButtons = {}
for _, button in ipairs(extraButtons) do
  table.insert(M.nvdash.buttons, button)
end

M.cheatsheet = { theme = "grid" } -- simple/grid

M.mason = {
  cmd = true,
  -- Use names from mason.nvim
  -- For example, if you want to install "tsserver" you should use "typescript-language-server" in the list below
  pkgs = {
    -- Lua
    "lua-language-server",
    "vim-language-server",
    "stylua",

    -- IaC, DevXp, DevOps
    "ansible-language-server",
    "ansible-lint",
    -- "autotools-language-server",
    "dockerfile-language-server",
    "docker-compose-language-service",
    "shellcheck",
    "terraform-ls",
    "tflint",
    -- "tfsec", -- replaced by trivy
    "trivy",

    -- Web Development
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    -- "deno",
    -- "vue-language-server",
    -- "tailwindcss-language-server",
    -- "emmet_language_server",
    -- "eslint-lsp",
    "eslint_d",
    "prettier",

    -- Markdown / Notes
    "marksman",
    "markdownlint",

    -- Nix
    "nil",

    -- PHP
    -- "intelephense",

    -- Python
    "autopep8",
    "pyright",

    -- C/C++
    -- "clangd",
    -- "clang-format",

    -- CMake
    -- "neocmakelsp",

    -- Java
    -- "jdtls",
    -- "kotlin-language-server",

    -- Toml
    "taplo",

    -- Yaml
    "yaml-language-server",
    "yamllint",

    -- Python
    -- "basedpyright",

    -- Go
    "delve",
    "goimports",
    "goimports-reviser",
    "golangci-lint",
    "golangci-lint-langserver",
    "gopls",

    -- C#
    -- "omnisharp",
    -- "omnisharp-mono",
  },
}

-- Disable signature help because it conflicts with folke/noice.nvim plugin
M.lsp = { signature = false }

M.base46 = {
  theme = "mountain",
  transparency = false,
  theme_toggle = { "mountain", "one_light" },
  hl_override = highlights.override,
  hl_add = highlights.add,
  integrations = {
    "notify",
    "dap",
    "trouble",
  },
}

-- M.lazy_nvim = require "core.lazy" -- config for lazy.nvim startup options

-- M.plugins = "plugins"

-- check core.mappings for table structure
-- M.mappings = require "mappings"

M.base46.hl_override = {
  DevIconMd = { fg = "#FFFFFF", bg = "NONE" },
  FloatTitle = { link = "FloatBorder" },
  CmpBorder = { link = "FloatBorder" },
  CmpDocBorder = { link = "FloatBorder" },
  TelescopeBorder = { link = "FloatBorder" },
  TelescopePromptBorder = { link = "FloatBorder" },
  NeogitDiffContext = { bg = "NONE" },
  NeogitDiffContextHighlight = { bg = "NONE" },
  -- BUG: (types) fg accepts a table
  TbBufOffModified = { fg = { "green", "black", 50 } }, ---@diagnostic disable-line
  ["@comment"] = { link = "Comment" },
  ["@keyword"] = { italic = true },
}

M.base46.hl_add = {
  YanVisual = { bg = "lightbg" },
  LspInfoBorder = { link = "FloatBorder" },
  NvimTreeGitStagedIcon = { fg = "vibrant_green" },
  St_HarpoonInactive = { link = "StText" },
  St_HarpoonActive = { link = "St_LspHints" },
  MarkviewLayer2 = { bg = "#171B21" },
  MarkviewCode = { link = "MarkviewLayer2" },
  HelpviewCode = { link = "MarkviewLayer2" },
  HelpviewInlineCode = { link = "MarkviewInlineCode" },
  HelpviewCodeLanguage = { link = "MarkviewCode" },
  CodeActionSignHl = { fg = "#F9E2AF" },
  ["@number.luadoc"] = { fg = "Comment" },
  ["@markup.quote.markdown"] = { bg = "NONE" },
  ["@markup.raw.block.markdown"] = { link = "MarkviewLayer2" },
}

local theme_customs = require("serpro69.chadrc_aux").themes_customs[M.base46.theme]
M.base46 = theme_customs and vim.tbl_deep_extend("force", M.base46, theme_customs) or M.base46

-- override base46 with own settings
-- avoid merge conflicts when upstream changes
-- profit
local base46_overrides = require("serpro69.chadrc_aux").base46_overrides
M.base46 = base46_overrides and vim.tbl_deep_extend("force", M.base46, base46_overrides) or M.base46

M.colorify = {
  enabled = true,
  mode = "virtual",
  virt_text = "󱓻 ",
  highlight = { hex = true, lspvars = true },
}

return M
