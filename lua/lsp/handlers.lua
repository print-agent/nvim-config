--[[
lua/lsp/handlers.lua - LSP Event Handlers

Like Go's HTTP handlers for different endpoints,
these handle different LSP events and capabilities.

Think of this as:
  package handlers
  
  func HandleDefinition(w http.ResponseWriter, r *http.Request) { ... }
  func HandleCompletion(w http.ResponseWriter, r *http.Request) { ... }
--]]

local M = {}

-- LSP attach handler (like middleware that runs on every request)
function M.on_attach(client, bufnr)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- Code navigation (like API endpoint handlers)
  map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Code actions (like form submission handlers)
  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

  -- Workspace symbols (like search endpoints)
  map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
  map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

  -- Document highlighting (like real-time updates)
  M.setup_document_highlight(client, bufnr)

  -- Inlay hints toggle (like debug mode toggle)
  M.setup_inlay_hints(client, bufnr)
end

-- Setup document highlighting
function M.setup_document_highlight(client, bufnr)
  local function client_supports_method(client, method, bufnr)
    if client.supports_method then
      return client.supports_method(method, { bufnr = bufnr })
    end
    return client.server_capabilities and client.server_capabilities.documentHighlightProvider ~= nil
  end

  if client and client_supports_method(client, 'textDocument/documentHighlight', bufnr) then
    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = bufnr,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = bufnr,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
      end,
    })
  end
end

-- Setup inlay hints
function M.setup_inlay_hints(client, bufnr)
  local function client_supports_method(client, method, bufnr)
    if client.supports_method then
      return client.supports_method(method, { bufnr = bufnr })
    end
    return client.server_capabilities and client.server_capabilities.inlayHintProvider ~= nil
  end

  if client and client_supports_method(client, 'textDocument/inlayHint', bufnr) then
    vim.keymap.set('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, { buffer = bufnr, desc = '[T]oggle Inlay [H]ints' })
  end
end

return M
