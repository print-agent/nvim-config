--[[
lua/plugins/lsp.lua - Language Server Protocol Integration

Like Go's service discovery and API gateway,
this manages connections to various language servers.

Think of this as:
  package gateway
  
  func RegisterService(name string, config ServiceConfig) { ... }
  func RouteRequest(lang string) LanguageServer { ... }
--]]

return {
  -- Main LSP configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Server installer (like package manager)
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Status updates (like health checks)
      { 'j-hui/fidget.nvim', opts = {} },

      -- Completion integration
      'saghen/blink.cmp',
    },
    config = function()
      -- Import our LSP configuration modules
      local lsp_handlers = require 'lsp.handlers'
      local lsp_servers = require 'lsp.servers'
      local lsp_utils = require 'lsp.utils'

      -- Setup diagnostics
      lsp_utils.setup_diagnostics()

      -- Setup LSP attach handler (like middleware registration)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          lsp_handlers.on_attach(vim.lsp.get_client_by_id(event.data.client_id), event.buf)
        end,
      })

      -- Get enhanced capabilities from completion engine
      local capabilities = lsp_utils.get_capabilities()

      -- Install tools and servers
      require('mason-tool-installer').setup {
        ensure_installed = lsp_servers.ensure_installed,
      }

      -- Setup each language server
      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = lsp_servers.servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
