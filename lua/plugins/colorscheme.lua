--[[
lua/plugins/colorscheme.lua - Theme Configuration

Like Go's frontend styling or CSS themes,
this handles the visual appearance of the editor.

Think of this as:
  package theme

  type Theme struct {
    Primary   string
    Secondary string
    Dark      bool
  }

  func Apply(theme Theme) { ... }
--]]

return {
  -- Tokyo Night theme (lazy-loaded)
  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'storm', -- Optional: Set a specific variant
        styles = {
          comments = { italic = false },
        },
      }
      -- Only call this if you want to switch to tokyonight
      -- vim.cmd.colorscheme 'tokyonight'
    end,
  },

  -- Rose Pine theme (lazy-loaded)
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        styles = {
          italic = true, -- Rose Pine uses `italic` instead of `comments`
        },
      }
      -- Only call this if you want to switch to rose-pine
      -- vim.cmd.colorscheme 'rose-pine'
    end,
  },

  -- Lackluster theme (lazy-loaded)
  {
    'slugbyte/lackluster.nvim',
    name = 'lackluster',
    lazy = true,
    priority = 1000,
    config = function()
      require('lackluster').setup {
        -- No `styles` field; customize highlights if needed
        tweak_color = {
          comment = 'italic', -- Enable italic comments
        },
      }
      -- Only call this if you want to switch to lackluster
      -- vim.cmd.colorscheme 'lackluster'
    end,
  },

  -- Moonfly theme (active)
  {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    lazy = true,
    priority = 1000,
    config = function()
      -- Enable true colors (required for Moonfly)
      vim.opt.termguicolors = true
      -- Only call this if you want to switch to moonfly
      -- vim.cmd.colorscheme 'moonfly'
      -- Enable italic comments
      vim.api.nvim_set_hl(0, 'Comment', { italic = true })
    end,
  },

  -- Nightfly theme (active)
  {
    'bluz71/vim-nightfly-colors',
    name = 'nightfly',
    lazy = false, -- Load immediately
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      -- Set the colorscheme
      vim.cmd.colorscheme 'nightfly'
      vim.api.nvim_set_hl(0, 'Comment', { italic = true })
    end,
  },

  -- Aura theme (lazy-loaded)
  {
    'baliestri/aura-theme',
    lazy = true,
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
      -- Only call this if you want to switch to aura
      -- vim.cmd.colorscheme 'aura-dark' -- Choose a variant (e.g., 'aura-dark', 'aura-soft-dark')
    end,
  },
}
