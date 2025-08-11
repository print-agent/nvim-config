--[[
lua/core/options.lua - Editor Configuration

Like Go's app configuration (config.yaml, environment variables),
this sets up all editor-wide settings and preferences.

Think of this as:
  package config

  type Config struct {
    Debug      bool
    Port       int
    Database   string
  }

  func Load() Config { ... }
--]]

-- Set leader keys (like setting global app constants)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- UI Configuration
vim.g.have_nerd_font = true

-- Line numbers and display
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true

-- Behavior settings
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.confirm = true

-- Search configuration
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split'

-- Performance settings
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Split behavior
vim.o.splitright = true
vim.o.splitbelow = true

-- Scrolling
vim.o.scrolloff = 10

-- Whitespace visualization
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Clipboard integration (async to avoid startup delay)
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
