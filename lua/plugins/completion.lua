--[[
lua/plugins/completion.lua - Autocompletion

Like Go's input validation and auto-suggestion systems,
this provides intelligent code completion.

Think of this as:
  package completion
  
  func SuggestCompletions(input string) []Suggestion { ... }
  func ValidateInput(input string) error { ... }
--]]

return {
  -- Main completion engine
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet engine (like template system)
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- Pre-made snippets (like template library)
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = {
        -- 'default' for <c-y> to accept, similar to built-in completions
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        preset = 'default',
      },

      appearance = {
        -- 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = 'mono',
      },

      completion = {
        -- Auto-show documentation after delay
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Use Lua fuzzy matching implementation
      fuzzy = { implementation = 'lua' },

      -- Function signature help
      signature = { enabled = true },
    },
  },

  -- Lua development enhancements
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
