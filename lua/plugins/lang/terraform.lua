return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- tofu linter incorrectly detects the directory of the opened file,
        -- which results in errors for modules that it things are not installed
        -- See: https://github.com/LazyVim/LazyVim/issues/6851
        terraform = { "tofu", "tflint", "trivy" },
        tf = { "tofu", "tflint", "trivy" },
        -- terraform = { "tflint", "trivy" },
        -- tf = { "tflint", "trivy" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        hcl = { "packer_fmt" },
        terraform = { "tofu_fmt" },
        tf = { "tofu_fmt" },
        ["terraform-vars"] = { "tofu_fmt" },
      },
    },
  },
}
