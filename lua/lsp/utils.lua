--[[
lua/lsp/utils.lua - LSP Utilities

Like Go's utility packages (helpers, validators, formatters),
these are reusable functions for LSP operations.

Think of this as:
  package utils
  
  func ValidateEmail(email string) bool { ... }
  func FormatResponse(data interface{}) []byte { ... }
--]]

local M = {}

-- Configure diagnostics display (like error formatting)
function M.setup_diagnostics()
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        return diagnostic.message
      end,
    },
  }
end

-- Get LSP capabilities (like defining API contract)
function M.get_capabilities()
  -- Check if blink.cmp is available for enhanced capabilities
  local has_blink, blink = pcall(require, 'blink.cmp')
  if has_blink then
    return blink.get_lsp_capabilities()
  end

  -- Fallback to default capabilities
  return vim.lsp.protocol.make_client_capabilities()
end

-- Check if client supports method (version compatibility)
function M.client_supports_method(client, method, bufnr)
  -- Use the modern API if available (Neovim 0.10+)
  if client.supports_method then
    return client.supports_method(method, { bufnr = bufnr })
  end

  -- Fallback for older versions - check server capabilities directly
  if not client.server_capabilities then
    return false
  end

  -- Map common LSP methods to server capabilities
  local capability_map = {
    ['textDocument/hover'] = 'hoverProvider',
    ['textDocument/signatureHelp'] = 'signatureHelpProvider',
    ['textDocument/definition'] = 'definitionProvider',
    ['textDocument/references'] = 'referencesProvider',
    ['textDocument/documentHighlight'] = 'documentHighlightProvider',
    ['textDocument/documentSymbol'] = 'documentSymbolProvider',
    ['textDocument/formatting'] = 'documentFormattingProvider',
    ['textDocument/rangeFormatting'] = 'documentRangeFormattingProvider',
    ['textDocument/rename'] = 'renameProvider',
    ['textDocument/codeAction'] = 'codeActionProvider',
    ['textDocument/inlayHint'] = 'inlayHintProvider',
  }

  local capability = capability_map[method]
  if capability then
    return client.server_capabilities[capability] ~= nil
  end

  -- Default to true for unknown methods
  return true
end

return M
