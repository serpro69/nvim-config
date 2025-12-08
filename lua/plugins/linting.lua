local tofu = require("lint").linters.tofu

return {
  {
    "mfussenegger/nvim-lint",
    event = "LspAttach",
    optional = true,
    opts = function(_, opts)
      opts.linters.tofu = function()
        local linter = tofu()
        -- this still returns null for some reason
        -- local root_dir = vim.lsp.buf.list_workspace_folders()[1]
        local ok, lspconfig = pcall(require, "lspconfig")
        if ok then
          local root_pattern = lspconfig.util.root_pattern("\\.terraform")
          local root_dir = root_pattern(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.:h"))
          if root_dir ~= nil then
            linter.args = {
              "-chdir=" .. root_dir,
              "validate",
              "-json",
            }
          else
            linter.cmd = "echo"
          end
        end
        return linter
      end
    end,
  },
}
