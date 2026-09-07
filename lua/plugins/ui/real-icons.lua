---@type LazySpec
-- NOTE: Graphical File Icons
return {
  "Mirsmog/real-icons.nvim",
  -- Disabled: writes Kitty Graphics Protocol escapes to the terminal (via tmux
  -- passthrough). Unreliable through tmux and unsupported by iTerm2, which
  -- desyncs clipboard/paste state — see clipboard "target STRING not available"
  -- errors and terminal version strings leaking into the buffer.
  enabled = false,
  build = ":RealIconsInstallPack material",
  opts = {
    pack = "material",
    integrations = {
      telescope = true,
      fzf_lua = true,
      neo_tree = true,
      nvim_tree = true,
      snacks_picker = true,
      oil = true,
      lualine = true,
      bufferline = true,
    },
  },
}
