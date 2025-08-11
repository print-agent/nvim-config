--[[
lua/core/init.lua - Core Package Initialization

Like Go's package init functions, this loads all core modules:
  - options.lua    (like app configuration)  
  - keymaps.lua    (like route definitions)
  - autocmds.lua   (like event handlers/middleware)

Think of this as:
  package core
  import (
    "nvim/core/options"
    "nvim/core/keymaps" 
    "nvim/core/autocmds"
  )
  func Init() {
    options.Setup()
    keymaps.Setup()  
    autocmds.Setup()
  }
--]]

-- Load core modules in order
require 'core.options'
require 'core.keymaps'
require 'core.autocmds'
