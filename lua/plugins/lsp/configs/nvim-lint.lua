local linters_by_ft = {
  javascriptreact = { "eslint" },
  javascript = { "eslint" },
  markdown = { "markdownlint" },
  sh = { "shellcheck" },
  -- tf = { "tflint", "trivy" },
  -- terraform = { "tflint", "trivy" },
  typescript = { "eslint" },
  typescriptreact = { "eslint" },
  yaml = { "yamllint" },
  -- github = { "actionlint" },
}

---@type NvPluginSpec
-- NOTE: Linting
return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  enabled = false,
  config = function()
    require("lint").linters_by_ft = linters_by_ft
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
