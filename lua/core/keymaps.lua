--[[
lua/core/keymaps.lua - Key Bindings

Enhanced with better error handling and simplified LSP navigation
--]]

local keymap = vim.keymap.set

-- Clear search highlighting
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostic navigation
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode escape
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Function navigation using LSP with error handling
local function safe_lsp_request(method, callback)
  return function()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    if #clients == 0 then
      vim.notify('No LSP clients attached', vim.log.levels.WARN)
      return
    end

    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    vim.lsp.buf_request(0, method, params, callback)
  end
end

local function goto_function(direction)
  local callback = function(_, result)
    if not result or vim.tbl_isempty(result) then
      vim.notify('No functions found', vim.log.levels.INFO)
      return
    end

    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local functions = {}

    -- Extract functions from symbols (handle nested symbols)
    local function extract_functions(symbols)
      for _, symbol in ipairs(symbols) do
        if symbol.kind == vim.lsp.protocol.SymbolKind.Function or symbol.kind == vim.lsp.protocol.SymbolKind.Method then
          table.insert(functions, {
            name = symbol.name,
            line = symbol.range.start.line + 1,
          })
        end
        if symbol.children then
          extract_functions(symbol.children)
        end
      end
    end

    extract_functions(result)

    if #functions == 0 then
      vim.notify('No functions found', vim.log.levels.INFO)
      return
    end

    -- Sort functions by line number
    table.sort(functions, function(a, b)
      return a.line < b.line
    end)

    local target_function
    if direction == 'next' then
      -- Find next function after current line
      for _, func in ipairs(functions) do
        if func.line > current_line then
          target_function = func
          break
        end
      end
      -- If no next function, wrap to first
      if not target_function then
        target_function = functions[1]
      end
    else -- direction == 'prev'
      -- Find previous function before current line
      for i = #functions, 1, -1 do
        if functions[i].line < current_line then
          target_function = functions[i]
          break
        end
      end
      -- If no previous function, wrap to last
      if not target_function then
        target_function = functions[#functions]
      end
    end

    if target_function then
      vim.api.nvim_win_set_cursor(0, { target_function.line, 0 })
      vim.cmd 'normal! ^' -- Move to first non-blank character
      vim.notify(string.format('Function: %s', target_function.name), vim.log.levels.INFO)
    end
  end

  return safe_lsp_request('textDocument/documentSymbol', callback)
end

-- LSP-based function navigation
keymap('n', ']]', goto_function 'next', { desc = 'Next function' })
keymap('n', '[[', goto_function 'prev', { desc = 'Previous function' })

-- Function text objects work with mini.ai:
-- vaf - select whole function (with declaration)
-- vif - select function body (inner)
-- daf - delete whole function
-- yif - yank function body
-- 2vaf - select 2nd function from cursor position
-- etc.
