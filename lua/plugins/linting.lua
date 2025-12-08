local tofu = require("lint").linters.tofu

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        tofu = function()
          local linter = tofu()
          -- this still returns null for some reason
          -- local root_dir = vim.lsp.buf.list_workspace_folders()[1]
          local ok, lspconfig = pcall(require, "lspconfig")
          if ok then
            local root_dir = lspconfig.util.root_pattern("\\.terraform")
            linter.args = {
              "-chdir=" .. root_dir(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.:h")),
              "validate",
              "-json",
            }
          end
          return linter
        end,
      },
    },
  },
}
