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
      customTags = {
        -- mkdocs
        -- ref: https://www.mkdocs.org/user-guide/configuration/#environment-variables
        -- ref: https://squidfunk.github.io/mkdocs-material/creating-your-site/#minimal-configuration
        -- "!ENV scalar",
        -- "!ENV sequence",
        -- "!relative scalar",
        -- "tag:yaml.org,2002:python/name:material.extensions.emoji.to_svg",
        -- "tag:yaml.org,2002:python/name:material.extensions.emoji.twemoji",
        -- "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format",
        -- "tag:yaml.org,2002:python/object/apply:pymdownx.slugs.slugify mapping",
      },
    },
  },
}
