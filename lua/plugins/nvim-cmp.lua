---@type NvPluginSpec
-- NOTE: Completion Engine

return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  init = function()
    vim.keymap.set("n", "<leader>oa", function()
      vim.g.toggle_cmp = not vim.g.toggle_cmp
      if vim.g.toggle_cmp then
        vim.notify("Toggled On", vim.log.levels.INFO, { title = "Autocomplete" })
      else
        vim.notify("Toggled Off", vim.log.levels.INFO, { title = "Autocomplete" })
      end
    end, { desc = "Options | Toggle Autocomplete" })
  end,
  config = function(_, opts)
    -- table.insert(opts.sources, 2, { name = "codeium" })
    -- table.insert(opts.sources, 1, { name = "supermaven" })

    opts.mapping = vim.tbl_extend("force", {}, opts.mapping, {
      -- You can add here new mappings.
    })

    opts.completion["completeopt"] = "menu,menuone,noselect" -- disable autoselect

    opts.enabled = function()
      return (vim.g.toggle_cmp and vim.bo.buftype == "")
    end

    require("luasnip").filetype_extend("javascriptreact", { "html" })
    require("luasnip").filetype_extend("typescriptreact", { "html" })
    require("luasnip").filetype_extend("svelte", { "html" })
    require("luasnip").filetype_extend("vue", { "html" })
    require("luasnip").filetype_extend("php", { "html" })
    require("luasnip").filetype_extend("javascript", { "javascriptreact" })
    require("luasnip").filetype_extend("typescript", { "typescriptreact" })

    --NOTE: add border for cmp window
    if vim.g.border_enabled then
      opts.window = {
        completion = require("cmp").config.window.bordered(),
        documentation = require("cmp").config.window.bordered(),
      }
    end

    require("cmp").setup(opts)

    local cmdline_mappings = vim.tbl_extend("force", {}, require("cmp").mapping.preset.cmdline(), {
      -- ["<CR>"] = { c = require("cmp").mapping.confirm { select = true } },
    })

    require("cmp").setup.cmdline(":", {
      mapping = cmdline_mappings,
      sources = {
        { name = "cmdline" },
      },
    })
  end,
  dependencies = {
    -- For Rust
    {
      "saecki/crates.nvim",
      tag = "v0.4.0",
      opts = {},
    },
    -- Commandline completions
    {
      "hrsh7th/cmp-cmdline",
    },
    -- AI Autocomplete
    {
      "Exafunction/codeium.nvim",
      enabled = false,
      opts = {
        enable_chat = true,
      },
    },
    {
      "supermaven-inc/supermaven-nvim",
      -- commit = "df3ecf7",
      commit = "40bde487fe31723cdd180843b182f70c6a991226",
      event = "BufReadPost",
      enabled = false,
      opts = {
        disable_keymaps = false,
        disable_inline_completion = false,
        keymaps = {
          accept_suggestion = "<C-;>",
          clear_suggestion = "<Nop>",
          accept_word = "<C-y>",
        },
      },
    },
    {
      "zbirenbaum/copilot.lua", -- AI programming
      enabled = true,
      event = "InsertEnter",
      init = function()
        require("legendary").commands {
          itemgroup = "Copilot",
          commands = {
            {
              ":CopilotToggle",
              function()
                require("copilot.suggestion").toggle_auto_trigger()
              end,
              description = "Toggle on/off for buffer",
            },
          },
        }
        require("legendary").keymaps {
          itemgroup = "Copilot",
          description = "Copilot suggestions...",
          icon = "",
          keymaps = {
            {
              "<C-a>",
              function()
                require("copilot.suggestion").accept()
              end,
              description = "Accept suggestion",
              mode = { "i" },
            },
            {
              "<C-x>",
              function()
                require("copilot.suggestion").dismiss()
              end,
              description = "Dismiss suggestion",
              mode = { "i" },
            },
            {
              "<C-\\>",
              function()
                require("copilot.panel").open()
              end,
              description = "Show Copilot panel",
              mode = { "n", "i" },
            },
          },
        }
      end,
      opts = {
        panel = {
          auto_refresh = true,
        },
        suggestion = {
          auto_trigger = true, -- Suggest as we start typing
          keymap = {
            accept_word = "<C-l>",
            accept_line = "<C-j>",
          },
        },
        filetypes = {
          ["*"] = function()
            local cwd = vim.loop.cwd()
            local filename = vim.fs.basename(vim.api.nvim_buf_get_name(0))
            local filepath = vim.api.nvim_buf_get_name(0)

            local dir_match = function(dirs)
              for _, dir in ipairs(dirs) do
                if cwd:match(dir) ~= nil then
                  return true
                end
              end
              return false
            end

            if
              -- disable for certain projets
              dir_match { "evergreen%-dissemination", "norsk" }
              -- disable for all hidden files
              or filename:match "^%."
              -- disable for terraform .tfvars
              or filepath:match "%.tfvars$"
            then
              return false
            end
            return true
          end,
        },
      },
    },
    {
      "olimorris/codecompanion.nvim",
      enabled = true,
      event = "BufReadPost",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim", -- Optional
        {
          "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
          opts = {},
        },
      },
      config = function()
        require("codecompanion").setup {
          adapters = {
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                schema = {
                  model = {
                    -- https://platform.openai.com/docs/models
                    default = "gpt-4o",
                  },
                },
              })
            end,
          },
          strategies = {
            chat = {
              adapter = "copilot",
            },
            inline = {
              adapter = "copilot",
            },
            agent = {
              adapter = "copilot",
            },
          },
          display = {
            chat = {
              window = {
                layout = "vertical", -- float|vertical|horizontal|buffer
              },
            },
            inline = {
              diff = {
                hl_groups = {
                  added = "DiffAdd",
                },
              },
            },
          },
          opts = {
            log_level = "DEBUG",
          },
        }
      end,
      init = function()
        vim.cmd [[cab cc CodeCompanion]]
        require("legendary").keymaps {
          {
            itemgroup = "CodeCompanion",
            icon = "",
            description = "Use the power of AI...",
            keymaps = {
              {
                "<C-a>",
                "<cmd>CodeCompanionActions<CR>",
                description = "Open the CodeCompanion action picker",
                mode = { "n", "v" },
              },
              {
                "<LocalLeader>a",
                "<cmd>CodeCompanionToggle<CR>",
                description = "Open CodeCompanion chat prompt",
                mode = { "n", "v" },
              },
              {
                "ga",
                "<cmd>CodeCompanionAdd<CR>",
                description = "Add selected text to CodeCompanion",
                mode = { "n", "v" },
              },
            },
          },
        }
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
      build = "make install_jsregexp",
    },
  },
}
