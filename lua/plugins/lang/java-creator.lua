---@type LazySpec
-- NOTE: Java File Creation
return {
  {
    "alessio-vivaldelli/java-creator-nvim",
    ft = "java",
    opts = {
      -- Default configuration
      keymaps = {
        java_new = "<leader>cJn",
        java_class = "<leader>cJc",
        java_interface = "<leader>cJi",
        java_enum = "<leader>cJe",
        java_record = "<leader>cJr",
        java_abstract_class = "<leader>cJa",
      },
      options = {
        auto_open = true, -- Open file after creation
        java_version = 17, -- Minimum Java version
      },
    },
    keys = {
      {
        "<leader>cJd",
        function()
          require("config.utils.spring_deps").select_and_add()
        end,
        desc = "Add Spring Boot Dependency",
        ft = "java",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>cJ", group = "Java" },
      },
    },
  },
}
