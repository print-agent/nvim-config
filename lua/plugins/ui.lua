--[[
lua/plugins/ui.lua - UI Components and Interface

Like Go's web UI framework and component library,
this provides interface elements and visual enhancements.

Think of this as:
  package ui

  func StatusBar() Component { ... }
  func HelpModal() Component { ... }
  func KeymapHints() Component { ... }
--]]

return {
  -- Which-key for keymap hints (like interactive help system)
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      -- Delay before showing which-key
      delay = 0,

      -- Icon configuration
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Key group descriptions (like menu categories)
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- Mini.nvim collection (like utility component library)
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better text objects (like enhanced selectors)
      require('mini.ai').setup { n_lines = 500 }

      -- Surround operations (like bracket management)
      require('mini.surround').setup()

      -- Simple statusline (like status bar component)
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- Custom location format
      statusline.section_location = function(args)
        if statusline.is_truncated(args.trunc_width or 75) then
          return '%2l : %-2v'
        else
          return ' %p%%   %2l:%-2v'
        end
      end
    end,
  },

  -- Todo comments highlighting (like code annotation system)
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Optional: File explorer (uncomment if needed)
  -- {
  --   'nvim-neo-tree/neo-tree.nvim',
  --   version = '*',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-tree/nvim-web-devicons',
  --     'MunifTanjim/nui.nvim',
  --   },
  --   lazy = false,
  --   cmd = 'Neotree',
  --   keys = {
  --     { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  --   },
  --   opts = {
  --     filesystem = {
  --       window = {
  --         mappings = {
  --           ['\\'] = 'close_window',
  --         },
  --       },
  --     },
  --   },
  -- },
}
