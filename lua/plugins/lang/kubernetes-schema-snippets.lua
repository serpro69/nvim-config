---@type LazySpec
-- NOTE: For Kubernetes Development
return {
  "KevinNitroG/kubernetes-schema-snippets.nvim",
  ft = "yaml",
  config = true,
  dependencies = "L3MON4D3/LuaSnip",
  ---@module 'kubernetes-schema-snippets'
  ---@type KubernetesSchemaSnippets.Opts
  opts = {
    filetypes = {
      "yaml",
      "yml",
    },
    integrations = {
      kubernetes = true,
      kustomize = true,
      crds_catalog = true,
      argocd = true,
      flux2 = true,
    },
  },
}
