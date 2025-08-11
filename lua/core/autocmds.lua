--[[
lua/core/autocmds.lua - Auto Commands (Event Handlers)

Like Go's middleware or event handlers, these respond to 
specific editor events automatically.

Think of this as:
  package middleware
  
  func LoggingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w, r) {
      // do something on request
      next.ServeHTTP(w, r)
    })
  }
--]]

-- Highlight when yanking (copying) text
-- Like logging successful API responses
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto-resize splits when terminal is resized
-- Like graceful shutdown handling
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Resize splits when terminal is resized',
  group = vim.api.nvim_create_augroup('auto-resize', { clear = true }),
  callback = function()
    vim.cmd 'wincmd ='
  end,
})

-- Remove trailing whitespace on save
-- Like input sanitization middleware
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Remove trailing whitespace on save',
  group = vim.api.nvim_create_augroup('trim-whitespace', { clear = true }),
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.winrestview(save)
  end,
})
