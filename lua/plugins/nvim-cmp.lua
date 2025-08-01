---@type NvPluginSpec
-- NOTE: Completion Engine

local has_words_before = function()
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
end

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
  opts = function(_, opts)
    -- table.insert(opts.sources, 2, { name = "codeium" })
    -- table.insert(opts.sources, 1, { name = "supermaven" })
    table.insert(opts.sources, 2, { name = "copilot" })

    opts.mapping = vim.tbl_extend("force", {}, opts.mapping, {
      -- You can add here new mappings.
      -- ["<C-Tab>"] = function(fallback)
      --   if require("cmp").visible() and has_words_before() then
      --     require("cmp").select_next_item { behavior = require("cmp").SelectBehavior.Select }
      --   else
      --     fallback()
      --   end
      -- end,
      -- ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
      --   if require("cmp").visible() then
      --     require("cmp").select_prev_item { behavior = require("cmp").SelectBehavior.Select }
      --   else
      --     fallback()
      --   end
      -- end),
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
      config = function()
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
        copilot_model = "gpt-4o-copilot",
        panel = {
          -- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp
          enabled = true,
          auto_refresh = true,
        },
        suggestion = {
          -- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp
          enabled = true,
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
      "zbirenbaum/copilot-cmp",
      enabled = false,
      config = function()
        require("copilot_cmp").setup()
      end,
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
                -- suggested by @lucobellic (ref: https://github.com/olimorris/codecompanion.nvim/discussions/279) to improve responses from the copilot models
                -- see also https://github.com/lucobellic/nvim-config/blob/d8b0e7d34652704cfba85c130663823a0200bf77/lua/plugins/completion/codecompanion.lua#L53
                opts = { stream = false },
                schema = {
                  model = {
                    -- https://platform.openai.com/docs/models
                    default = "gpt-4o",
                  },
                },
              })
            end,
            gemini = function()
              return require("codecompanion.adapters").extend("gemini", {
                -- env = {
                --   api_key = os.getenv "GEMINI_API_KEY",
                -- },
                schema = {
                  model = {
                    -- https://ai.google.dev/gemini-api/docs/models/experimental-models
                    default = require("serpro69.plugins_aux").ai_models.gemini.pro,
                  },
                },
              })
            end,
          },
          strategies = {
            chat = {
              adapter = "gemini",
            },
            inline = {
              adapter = "gemini",
            },
            agent = {
              adapter = "gemini",
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
