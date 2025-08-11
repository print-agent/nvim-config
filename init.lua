--[[
init.lua - Main Entry Point

Like Go's main() function, this file only:
1. Sets up the module loader (like GOPATH)
2. Calls the core initialization
3. Keeps everything else in separate modules

Think of this as:
  package main
  import "nvim/core"
  func main() { core.Init() }
--]]

-- Bootstrap runtime (lazy.nvim)
require 'bootstrap'

-- Initialize core modules (like importing core package)
require 'core'

-- Load all plugins via lazy.nvim
require('lazy').setup('plugins', {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
