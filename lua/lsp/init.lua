--[[
lua/lsp/init.lua - LSP Package Initialization

Like Go's service initialization, this sets up all
language server integrations and handlers.

Think of this as:
  package lsp
  
  import (
    "nvim/lsp/handlers"
    "nvim/lsp/servers"
  )
  
  func Init() {
    handlers.Setup()
    servers.Setup()
  }
--]]

local M = {}

-- Setup function called by plugins that need LSP
function M.setup()
  require 'lsp.handlers'
  require 'lsp.servers'
end

return M
