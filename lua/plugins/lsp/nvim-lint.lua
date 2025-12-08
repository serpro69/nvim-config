-- Some linters are exposed as functions
-- ref: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#customize-built-in-linters
local original = {
  tofu = require("lint").linters.tofu,
  trivy = require("lint").linters.trivy,
}

local root_dir = function(...)
  local ok, lspconfig = pcall(require, "lspconfig")
  if ok then
    local root_pattern = lspconfig.util.root_pattern(...)
    return root_pattern(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.:h"))
  end
  return nil
end

---@type LazySpec
-- NOTE: File Linting
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = {
        -- BUG: terraform_validate and tofu linters incorrectly detect the root terraform directory,
        -- which results in errors for modules that it things are not installed
        -- In addition to that, it also does not work very well
        --   even with below modifications that fix root dir discovery
        -- See: https://github.com/LazyVim/LazyVim/issues/6851
        --      https://github.com/mfussenegger/nvim-lint/issues/885
        -- terraform = { "tofu", "tflint", "trivy" },
        -- tf = { "tofu", "tflint", "trivy" },
        terraform = { "tflint", "trivy" },
        tf = { "tflint", "trivy" },
      }
      opts.linters = {
        tofu = function()
          local linter = original.tofu()
          -- this still returns null for some reason
          -- local root_dir = vim.lsp.buf.list_workspace_folders()[1]
          local root = root_dir(".terraform")
          if root ~= nil then
            linter.args = {
              "-chdir=" .. root_dir,
              "validate",
              "-json",
            }
          end
          return linter
        end,

        -- trivy = function()
        --   local linter = original.trivy
        --   local root = root_dir(".terraform", "main.tf", ".git")
        --   if root ~= nil then
        --     linter.args = { "--scanners", "misconfig", "--format", "json", "fs", root }
        --     -- linter.args = { "fs", "--scanners", "secret,misconfig", "--format", "json", root }
        --   end
        --
        --   return linter
        -- end,
      }
    end,
  },
}
