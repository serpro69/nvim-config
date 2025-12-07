---@type LazySpec
-- NOTE: Neovim LSP Configuration
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "aznhe21/actions-preview.nvim",
  },
  opts = function(_, opts)
    local custom_path = "plugins.lsp.settings"

    local disabled_servers = {
      "phpactor",
      "rust_analyzer",
      -- add more if needed
    }

    local function is_disabled(server)
      return vim.tbl_contains(disabled_servers, server)
    end

    local function extend_server(server)
      -- Skip disabled servers
      if is_disabled(server) then
        return
      end

      -- Try to load custom settings
      local ok, custom = pcall(require, custom_path .. "." .. server)
      if ok and type(custom) == "table" then
        opts.servers[server] = vim.tbl_deep_extend("force", opts.servers[server] or {}, custom)
        opts.servers[server].keys = {
          {
            "<leader>ca",
            function()
              local ok_ap, ap = pcall(require, "actions-preview")
              if not ok_ap then
                vim.notify("Failed to load actions-preview plugin", vim.log.levels.ERROR, { title = "nvim-lspconfig" })
                vim.lsp.buf.code_action()
              else
                ap.code_actions()
              end
            end,
            desc = "Code Action",
            mode = { "n", "x" },
            has = "codeAction",
          },
        }
      end
    end

    -- Dynamically detect all server config files
    local settings_dir = vim.fn.stdpath("config") .. "/lua/" .. custom_path:gsub("%.", "/")
    local files = vim.fn.glob(settings_dir .. "/*.lua", false, true)

    for _, file in ipairs(files) do
      local server = vim.fn.fnamemodify(file, ":t:r")
      extend_server(server)
    end

    return opts
  end,
}
