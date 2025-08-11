--[[
lua/core/keymaps.lua - Key Bindings

Like Go's HTTP route definitions, this maps user input
to specific actions throughout the editor.

Think of this as:
  package routes
  
  func SetupRoutes() {
    http.HandleFunc("/", homeHandler)
    http.HandleFunc("/api", apiHandler)
  }
--]]

local keymap = vim.keymap.set

-- Clear search highlighting
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostic navigation (like error handling routes)
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode escape
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation (like service-to-service communication)
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Code navigation (like jumping between function definitions)
-- Match opening brace with optional indentation
keymap('n', ']]', '/\\v^\\s*.*\\{\\s*$<CR>', { desc = 'Next section start' })
keymap('n', '][', '/\\v^\\s*\\}<CR>', { desc = 'Next section end' })
keymap('n', '[[', '?\\v^\\s*.*\\{\\s*$<CR>', { desc = 'Previous section start' })
keymap('n', '[]', '?\\v^\\s*\\}<CR>', { desc = 'Previous section end' })

-- Optional: Disable arrow keys to enforce hjkl usage
-- (like enforcing coding standards)
-- keymap('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- keymap('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- keymap('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- keymap('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
