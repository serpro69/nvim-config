---@type NvPluginSpec
-- NOTE: Plugin Description
return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  event = {
    "BufReadPre " .. vim.fn.expand "~" .. "/obsidian/**.md",
    "BufNewFile " .. vim.fn.expand "~" .. "/obsidian/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "🌌 evergreen",
        path = "~/obsidian/evergreen-dissemination",
      },
      {
        name = "🇳🇴 norsk",
        path = "~/obsidian/norsk",
      },
    },

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "100_Logbook/110_Daily/" .. os.date "%Y" .. "/" .. os.date "%m",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "daylog" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "000_Infra/002_Templates/periodic_note/today.md",
    },

    -- Where to put new notes. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "010_Black_Hole",

    -- Optional, boolean or a function that takes a filename and returns a boolean.
    -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
    disable_frontmatter = true,

    templates = {
      folder = "000_Infra/002_Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
  },
}
