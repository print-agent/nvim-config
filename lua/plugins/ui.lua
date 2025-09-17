--[[
lua/plugins/ui.lua - ui components and interface

like go's web ui framework and component library,
this provides interface elements and visual enhancements.

think of this as:
  package ui

  func statusbar() component { ... }
  func helpmodal() component { ... }
  func keymaphints() component { ... }
--]]

return {
  -- which-key for keymap hints (like interactive help system)
  {
    'folke/which-key.nvim',
    event = 'vimenter',
    opts = {
      -- delay before showing which-key
      delay = 0,

      -- icon configuration
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          up = '<up> ',
          down = '<down> ',
          left = '<left> ',
          right = '<right> ',
          c = '<c-…> ',
          m = '<m-…> ',
          d = '<d-…> ',
          s = '<s-…> ',
          cr = '<cr> ',
          esc = '<esc> ',
          scrollwheeldown = '<scrollwheeldown> ',
          scrollwheelup = '<scrollwheelup> ',
          nl = '<nl> ',
          bs = '<bs> ',
          space = '<space> ',
          tab = '<tab> ',
          f1 = '<f1>',
          f2 = '<f2>',
          f3 = '<f3>',
          f4 = '<f4>',
          f5 = '<f5>',
          f6 = '<f6>',
          f7 = '<f7>',
          f8 = '<f8>',
          f9 = '<f9>',
          f10 = '<f10>',
          f11 = '<f11>',
          f12 = '<f12>',
        },
      },

      -- key group descriptions (like menu categories)
      spec = {
        { '<leader>s', group = '[s]earch' },
        { '<leader>t', group = '[t]oggle' },
        { '<leader>h', group = 'git [h]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- auto pairs (simplified configuration)
  {
    'windwp/nvim-autopairs',
    event = 'insertenter',
    config = function()
      local autopairs = require 'nvim-autopairs'
      autopairs.setup {
        check_ts = true,
        ts_config = {
          lua = { 'string' },
          javascript = { 'template_string' },
        },
        disable_filetype = { 'telescopeprompt', 'vim' },
      }
    end,
  },

  -- mini.nvim collection (like utility component library)
  {
    'echasnovski/mini.nvim',
    config = function()
      -- better text objects (like enhanced selectors)
      require('mini.ai').setup {
        n_lines = 500,

        -- custom text objects (keeping defaults for blocks and strings)
        custom_textobjects = {
          -- function objects (simplified treesitter approach)
          f = require('mini.ai').gen_spec.treesitter {
            a = { '@function.outer' },
            i = { '@function.inner' },
          },

          -- class objects
          c = require('mini.ai').gen_spec.treesitter {
            a = { '@class.outer', '@struct.outer' },
            i = { '@class.inner', '@struct.inner' },
          },

          -- loop objects
          l = require('mini.ai').gen_spec.treesitter {
            a = { '@loop.outer' },
            i = { '@loop.inner' },
          },

          -- conditional objects
          o = require('mini.ai').gen_spec.treesitter {
            a = { '@conditional.outer' },
            i = { '@conditional.inner' },
          },
        },

        -- enhanced mappings for navigation
        mappings = {
          around = 'a',
          inside = 'i',
          around_next = 'an',
          inside_next = 'in',
          around_last = 'al',
          inside_last = 'il',
          goto_left = 'g[',
          goto_right = 'g]',
        },
      }

      -- surround operations (like bracket management)
      require('mini.surround').setup()

      -- simple statusline (like status bar component)
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- custom location format
      statusline.section_location = function(args)
        local line = vim.fn.line '.'
        local col = vim.fn.col '.'
        local percent = math.floor((line / vim.fn.line '$') * 100)

        if statusline.is_truncated(args.trunc_width or 75) then
          return string.format('%d:%d', line, col)
        else
          return string.format(' %d%%   %d:%d', percent, line, col)
        end
      end
    end,
  },

  -- todo comments highlighting (like code annotation system)
  {
    'folke/todo-comments.nvim',
    event = 'vimenter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- optional: file explorer (uncomment if needed)
  -- {
  --   'nvim-neo-tree/neo-tree.nvim',
  --   version = '*',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-tree/nvim-web-devicons',
  --     'muniftanjim/nui.nvim',
  --   },
  --   lazy = false,
  --   cmd = 'neotree',
  --   keys = {
  --     { '\\', ':neotree reveal<cr>', desc = 'neotree reveal', silent = true },
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
