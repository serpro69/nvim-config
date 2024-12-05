return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas {
        extra = {
          {
            description = "MISE configuration files",
            fileMatch = {
              "mise.*.local.toml",
              "mise.local.toml",
              "mise.*.toml",
              "mise.toml",
              ".mise.*.local.toml",
              ".mise.local.toml",
              ".mise.*.toml",
              ".mise.toml",
            },
            name = "mise.json",
            url = "https://raw.githubusercontent.com/jdx/mise/refs/heads/main/schema/mise.json",
          },
          {
            description = "MISE configuration files",
            fileMatch = {
              "mise*tasks*.toml",
              ".mise*tasks*.toml",
            },
            name = "mise-task.json",
            url = "https://raw.githubusercontent.com/jdx/mise/refs/heads/main/schema/mise-task.json",
          },
        },
      },
      validate = { enable = true },
    },
  },
}
