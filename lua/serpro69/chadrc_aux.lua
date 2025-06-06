--- Credits: https://github.com/mgastonportillo/nvchad-config/blob/main/lua/gale/chadrc_aux.lua
local M = {}

M.themes_customs = {
  ["bearded-arc"] = {
    hl_override = {
      Comment = { fg = "#7589BF", italic = true },
      CursorLineNr = { fg = "yellow", bold = true },
      FloatBorder = { fg = "#7589BF", bg = "NONE" },
      TelescopeSelection = { bg = "black", fg = "#DDDDDD", bold = true },
      NvimTreeCursorLine = { bg = "black", fg = "nord_blue", bold = true },
      MatchWord = { fg = "NONE", bg = "black2" },
      MatchBackground = { link = "MatchWord" },
      NvimTreeRootFolder = { fg = "vibrant_green" },
      NvimTreeGitDirty = { link = "NvimTreeNormal" },
      TbBufOn = { link = "Normal" },
      StText = { fg = "#8386A8" },
      St_NormalMode = { fg = "blue", bg = "one_bg1" },
      St_InsertMode = { fg = "blue", bg = "one_bg1" },
      St_cwd = { fg = "red", bg = "one_bg1" },
      St_CommandMode = { bg = "one_bg1" },
      St_ConfirmMode = { bg = "one_bg1" },
      St_SelectMode = { bg = "one_bg1" },
      St_VisualMode = { bg = "one_bg1" },
      St_ReplaceMode = { bg = "one_bg1" },
      St_TerminalMode = { bg = "one_bg1" },
      St_NTerminalMode = { bg = "one_bg1" },
      LspInlayHint = { fg = "#7589BF", bg = "NONE" },
    },
  },

  ["eldritch"] = {
    hl_override = {
      Comment = { fg = "dark_purple", italic = true },
      CursorLineNr = { fg = "yellow", bold = true },
      FloatBorder = { fg = "purple", bg = "NONE" },
      TelescopeSelection = { bg = "black", fg = "#DDDDDD", bold = true },
      NvimTreeCursorLine = { bg = "black", fg = "purple", bold = true },
      MatchWord = { fg = "NONE", bg = "black2" },
      MatchBackground = { link = "MatchWord" },
      NvimTreeRootFolder = { fg = "vibrant_green" },
      NvimTreeGitDirty = { link = "NvimTreeNormal" },
      CodeActionSignHl = { fg = "yellow" },
      TbBufOn = { link = "St_Lsp" },
      StText = { fg = "#8386A8" },
      St_NormalMode = { bg = "blue", fg = "black" },
      St_InsertMode = { bg = "purple", fg = "black" },
      St_cwd = { bg = "yellow", fg = "black" },
      St_CommandMode = { bg = "black", reverse = true },
      St_ConfirmMode = { bg = "black", reverse = true },
      St_SelectMode = { bg = "black", reverse = true },
      St_VisualMode = { bg = "black", reverse = true },
      St_ReplaceMode = { bg = "black", reverse = true },
      St_TerminalMode = { bg = "black", reverse = true },
      St_NTerminalMode = { bg = "black", reverse = true },
      St_HarpoonActive = { link = "St_Ft" },
      LspInlayHint = { fg = "dark_purple", bg = "NONE" },
    },
  },
}

--- Show harpoon indicator in statusline
local harpoon_statusline_indicator = function()
  -- inspiration from https://github.com/letieu/harpoon-lualine
  local inactive = "%#St_HarpoonInactive#"
  local active = "%#St_HarpoonActive#"

  local options = {
    icon = active .. " ⇁ ",
    separator = "",
    indicators = {
      inactive .. "q",
      inactive .. "w",
      inactive .. "e",
      inactive .. "r",
      inactive .. "t",
      inactive .. "y",
    },
    active_indicators = {
      active .. "1",
      active .. "2",
      active .. "3",
      active .. "4",
      active .. "5",
      active .. "6",
    },
  }

  local list = require("harpoon"):list()
  local root_dir = list.config:get_root_dir()
  local current_file_path = vim.api.nvim_buf_get_name(0)
  local length = math.min(list:length(), #options.indicators)
  local status = { options.icon }

  local get_full_path = function(root, value)
    if vim.uv.os_uname().sysname == "Windows_NT" then
      return root .. "\\" .. value
    end

    return root .. "/" .. value
  end

  for i = 1, length do
    local value = list:get(i).value
    local full_path = get_full_path(root_dir, value)

    if full_path == current_file_path then
      table.insert(status, options.active_indicators[i])
    else
      table.insert(status, options.indicators[i])
    end
  end

  if length > 0 then
    table.insert(status, " ")
    return table.concat(status, options.separator)
  else
    return ""
  end
end

local stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

local filename = function()
  local icon = "  󰈚"
  local hl = ""
  local path = vim.api.nvim_buf_get_name(stbufnr())
  local name = (path == "" and "Empty") or vim.fs.basename(path)
  local ext = name:match "%.([^%.]+)$" or name

  if name ~= "Empty" then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      hl = "%#DevIcon" .. ext .. "#"
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and "  " .. ft_icon) or ("  " .. icon)
    end
  end

  return hl .. icon .. " %#StText#" .. name
end

local git_custom = function()
  local bufnr = stbufnr()
  if not vim.b[bufnr].gitsigns_head or vim.b[bufnr].gitsigns_git_status then
    return ""
  end

  local git_status = vim.b[bufnr].gitsigns_status_dict
  local clear_hl = "%#StText#"
  local add_hl = "%#St_Lsp#"
  local changed_hl = "%#StText#"
  local rm_hl = "%#St_LspError#"
  local branch_hl = "%#@function#"

  local added = (git_status.added and git_status.added ~= 0) and (add_hl .. "  " .. clear_hl .. git_status.added)
    or ""
  local changed = (git_status.changed and git_status.changed ~= 0)
      and (changed_hl .. "  " .. clear_hl .. git_status.changed)
    or ""
  local removed = (git_status.removed and git_status.removed ~= 0)
      and (rm_hl .. "  " .. clear_hl .. git_status.removed)
    or ""
  local branch_name = branch_hl .. " " .. clear_hl .. git_status.head

  return " " .. branch_name .. " " .. added .. changed .. removed
end

M.modules = {
  statusline = {
    separator = " ", -- Add space between modules
    hack = "%#@comment#%", -- Hack to make module highlight visible
    tint = "%#StText#", -- Force grey on modules that absorb neighbour colour

    modified = function()
      return vim.bo.modified and " *" or " "
    end, -- Show modified indicator

    bufnr = function()
      local bufnr = vim.api.nvim_get_current_buf()
      return "%#StText#" .. tostring(bufnr)
    end, -- Show current buffer number in statusline

    filename = filename,
    git_custom = git_custom,
    harpoon = harpoon_statusline_indicator,
  },

  tabufline = {
    fill = "%#TbFill#%=", -- Fill tabufline with TbFill hl
  },
}

return M
