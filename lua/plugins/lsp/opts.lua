local M = {}
local keymap = vim.keymap.set
-- local cmp_nvim_lsp = require "cmp_nvim_lsp"

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.lsp_keymaps = function(bufnr)
  -- keymap("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, silent = true })
  keymap("n", "gD", "<cmd>Lspsaga finder<cr>", { buffer = bufnr, silent = true })
  keymap("n", "gd", "<cmd>Lspsaga goto_definition<cr>", { buffer = bufnr, silent = true })
  -- keymap("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP | Code Action", silent = true })
  -- keymap("n", "gd", vim.lsp.buf.definition, {buffer = bufnr, silent = true})
  keymap("n", "gl", "<cmd>Lspsaga show_line_diagnostics<cr>", { buffer = bufnr, silent = true })
  keymap("n", "gp", "<cmd>Lspsaga peek_definition<cr>", { buffer = bufnr, silent = true })
  -- keymap("n", "K", vim.lsp.buf.hover, {buffer = bufnr, silent = true})
  keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", { buffer = bufnr, silent = true })
  keymap("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { buffer = bufnr, silent = true })
  keymap("v", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP | Code Action", silent = true })

  -- NOTE: own mappings (ref https://github.com/serpro69/nvim-config/commit/bbe9824da9fe024f6fc460520ec5e618740a888e)
  keymap("n", "gd", vim.lsp.buf.definition, { desc = "LSP | GoTo definition", buffer = bufnr, silent = true })
  keymap("n", "gD", vim.lsp.buf.declaration, { desc = "LSP | GoTo declaration", buffer = bufnr, silent = true })
  keymap("n", "gI", vim.lsp.buf.implementation, { desc = "LSP | GoTo implementation", buffer = bufnr, silent = true })
  keymap("n", "<leader>lD", "<cmd>Lspsaga finder<cr>", { buffer = bufnr, silent = true })
  keymap("n", "<leader>ld", "<cmd>Lspsaga goto_definition<cr>", { buffer = bufnr, silent = true })
  --
end

-- Highlight symbol under cursor
M.lsp_highlight = function(client, bufnr)
  if client:supports_method "textDocument/documentHighlight" then
    vim.api.nvim_create_augroup("lsp_document_highlight", {
      clear = false,
    })
    vim.api.nvim_clear_autocmds {
      buffer = bufnr,
      group = "lsp_document_highlight",
    }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

M.on_attach = function(client, bufnr)
  M.lsp_keymaps(bufnr)
  M.lsp_highlight(client, bufnr)
end

M.on_init = function(client, _)
  if client:supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

return M
