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
      "lsp_msg",
      "python_venv",
      "diagnostics",
      "command",
      "clients",
      "cwd",
      "total_lines",
    },
    modules = require("core.statusline").modules,
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

M.nvdash.header = get_header "wlcm3"

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
    "terraform-ls",
    "tflint",
    -- "tfsec", -- replaced by trivy
    "trivy",

    -- Web Development
    -- "css-lsp",
    -- "html-lsp",
    -- "typescript-language-server",
    -- "deno",
    -- "vue-language-server",
    -- "tailwindcss-language-server",
    -- "emmet_language_server",
    -- "eslint-lsp",
    -- "prettier",

    -- Markdown / Notes
    "marksman",
    "markdownlint",

    -- PHP
    -- "intelephense",

    -- C/C++
    -- "clangd",
    -- "clang-format",

    -- CMake
    -- "neocmakelsp",

    -- Java
    -- "jdtls",
    -- "kotlin-language-server",

    -- Yaml
    -- "yaml-language-server",

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

local themed_values = require("serpro69.chadrc_aux").theme_customs[M.base46.theme]

M.base46.hl_override = {
  CursorLineNr = { fg = "yellow", bold = true },
  FloatBorder = { fg = themed_values.border_fg, bg = "NONE" },
  TelescopeBorder = { link = "FloatBorder" },
  TelescopePromptBorder = { link = "FloatBorder" },
  TelescopeSelection = { bg = themed_values.curline_bg, fg = "#DDDDDD", bold = true },
  NvimTreeCursorLine = { bg = themed_values.curline_bg, fg = themed_values.curline_fg, bold = true },
  MatchWord = { fg = "NONE", bg = "black2" },
  MatchBackground = { link = "MatchWord" },
  NeogitDiffContext = { bg = "NONE" },
  NeogitDiffContextCursor = { bg = themed_values.curline_colour, bold = true },
  NeogitDiffContextHighlight = { bg = "NONE" },
  NvimTreeRootFolder = { fg = "vibrant_green" },
  NvimTreeGitDirty = { link = "NvimTreeNormal" },
  TbBufOn = { link = themed_values.buf_on_link },
  St_NormalMode = { fg = themed_values.st_normal_fg, bg = themed_values.st_bg },
  St_InsertMode = { fg = themed_values.st_insert_fg, bg = themed_values.st_bg },
  St_cwd = { fg = themed_values.st_cwd_fg, bg = themed_values.st_bg },
  St_CommandMode = { bg = themed_values.st_bg },
  St_ConfirmMode = { bg = themed_values.st_bg },
  St_SelectMode = { bg = themed_values.st_bg },
  St_VisualMode = { bg = themed_values.st_bg },
  St_ReplaceMode = { bg = themed_values.st_bg },
  St_TerminalMode = { bg = themed_values.st_bg },
  St_NTerminalMode = { bg = themed_values.st_bg },
  -- BUG: (types) fg can take a table as an argument
  TbBufOffModified = { fg = { "green", "black", 50 } }, ---@diagnostic disable-line
  FloatTitle = { fg = themed_values.border_fg, bg = "NONE" },
  LspInlayHint = { fg = themed_values.border_fg, bg = "NONE" },
  Comment = { fg = themed_values.comment_fg, italic = true },
  CmpBorder = { link = "FloatBorder" },
  CmpDocBorder = { link = "FloatBorder" },
  ["@comment"] = { link = "Comment" },
  ["@keyword"] = { italic = true },
}

M.base46.hl_add = {
  -- BUG: (types) fg can take a table as an argument
  BeardedCurline = { fg = { "black", -12 } }, ---@diagnostic disable-line
  LspInfoBorder = { link = "FloatBorder" },
  YankVisual = { bg = "lightbg" },
  St_HarpoonInactive = { link = "StText" },
  St_HarpoonActive = { link = "St_LspHints" },
  CodeActionSignHl = { fg = themed_values.code_action_fg },
  NvimTreeGitStagedIcon = { fg = "vibrant_green" },
  MarkviewLayer2 = { bg = "#171B21" },
  MarkviewCode = { link = "MarkviewLayer2" },
  HelpviewCode = { link = "MarkviewLayer2" },
  HelpviewInlineCode = { link = "MarkviewInlineCode" },
  HelpviewCodeLanguage = { link = "MarkviewCode" },
  ["@markup.quote.markdown"] = { bg = "NONE" },
  ["@markup.raw.block.markdown"] = { link = "MarkviewLayer2" },
  ["@number.luadoc"] = { fg = "Comment" },
}

return M
