return {
  filetypes = { "yaml", "yaml.ansible", "yaml.ghaction" },
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
      },
      schemas = vim.tbl_deep_extend(
        "force",
        require("schemastore").yaml.schemas(),
        { kubernetes = { "*.k8s.yml", "*.k8s.yaml" } }
      ),
    },
  },
}
