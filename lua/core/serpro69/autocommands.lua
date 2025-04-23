local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  desc = "Workaround for NvMenu being below NvimTree.",
  pattern = "NvMenu",
  group = augroup("FixNvMenuZindex", { clear = true }),
  callback = function()
    if vim.bo.ft == "NvMenu" then
      vim.api.nvim_win_set_config(0, { zindex = 99 })
    end
  end,
})

-- -- Set cursor position for nvdash
-- -- credits to @gale ( https://discord.com/channels/869557815780470834/869557816430563370/1287435062769356830 )
-- autocmd("FileType", {
--   pattern = "nvdash",
--   callback = function()
--     if vim.bo.ft == "nvdash" then
--       vim.api.nvim_win_set_cursor(0, { 18, 52 })
--     end
--   end,
-- })

-- Fix imports and formatting on save for Go
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format { async = false }
  end,
})

-- Notification on macro end
autocmd("RecordingEnter", {
  callback = function()
    local register = vim.fn.reg_recording()
    if register ~= "" then
      require("serpro69.notify").notify_macro_start(register)
    end
  end,
  desc = "Notify macro start",
})

-- Notification on macro end
autocmd("RecordingLeave", {
  callback = function()
    local register = vim.fn.reg_recording()
    if register ~= "" then
      require("serpro69.notify").notify_macro_end(register)
    end
  end,
  desc = "Notify macro end",
})
