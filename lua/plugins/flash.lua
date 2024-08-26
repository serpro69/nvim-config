---@type NvPluginSpec
-- NOTE: Search motions
return {
  "folke/flash.nvim",
  event = "CmdlineEnter",
  init = function()
    vim.keymap.set({ "n", "x", "o" }, "<leader>jj", function()
      require("flash").jump()
    end, { desc = "Flash | Jump" })

    vim.keymap.set({ "n", "x", "o" }, "<leader>jt", function()
      require("flash").treesitter()
    end, { desc = "Flash | Treesitter" })

    vim.keymap.set("o", "r", function()
      require("flash").remote()
    end, { desc = "Flash | Remote" })

    vim.keymap.set({ "o", "x" }, "R", function()
      require("flash").treesitter_search()
    end, { desc = "Flash | Treesitter Search" })

    -- vim.keymap.set({ "c" }, "<C-s>", function()
    --   require("flash").toggle()
    -- end, { desc = "Toggle Flash Search" })
  end,
  opts = {
    -- exclude common vim keys: r, i, p, x, c
    -- labels = "asdfghjklqwertyuiopzxcvbnm",
    labels = "asdfghjklqwetyuzvbnm",
    search = {
      -- search/jump in all windows
      multi_window = true,
      -- search direction
      forward = true,
      -- when `false`, find only matches in the given direction
      wrap = true,
      -- Each mode will take ignorecase and smartcase into account.
      -- * exact: exact match
      -- * search: regular search
      -- * fuzzy: fuzzy search
      -- * fun(str): custom function that returns a pattern
      --   For example, to only match at the beginning of a word:
      --   mode = function(str)
      --     return "\\<" .. str
      --   end,
      mode = "exact",
      -- behave like `incsearch`
      incremental = true,
      -- Excluded filetypes and custom window filters
      exclude = {
        "notify",
        "noice",
        "cmp_menu",
        function(win)
          -- exclude non-focusable windows
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
      -- Optional trigger character that needs to be typed before
      -- a jump label can be used. It's NOT recommended to set this,
      -- unless you know what you're doing
      trigger = "",
    },
    jump = {
      -- save location in the jumplist
      jumplist = true,
      -- jump position
      pos = "start", ---@type "start" | "end" | "range"
      -- add pattern to search history
      history = false,
      -- add pattern to search register
      register = false,
      -- clear highlight after jump
      nohlsearch = true,
      -- automatically jump when there is only one match
      autojump = false,
    },
    modes = {
      -- options used when flash is activated through
      -- a regular search with `/` or `?`
      search = {
        enabled = true, -- enable flash for search
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          -- `forward` will be automatically set to the search direction
          -- `mode` is always set to `search`
          -- `incremental` is set to `true` when `incsearch` is enabled
        },
      },
      -- options used when flash is activated through
      -- `f`, `F`, `t`, `T`, and `,` motions
      char = {
        enabled = true,
        -- by default all keymaps are enabled, but you can disable some of them,
        -- by removing them from the list.
        keys = { "f", "F", "t", "T", ",", ";" },
        search = { wrap = false },
        highlight = { backdrop = true },
        jump = { register = false },
        jump_labels = true,
      },
      -- options used for remote flash
      remote = {},
    },
  },
}
