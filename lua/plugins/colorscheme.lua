--[[
lua/plugins/colorscheme.lua - Theme Configuration

Optimized to load only the active theme, with optional theme switcher
--]]

-- Current active theme (change this to switch themes)
local ACTIVE_THEME = 'tokyonight'

local function setup_theme_switcher()
  -- Optional: Add a command to switch themes
  vim.api.nvim_create_user_command('ThemeSwitch', function(opts)
    local theme = opts.args
    if theme == '' then
      local themes = { 'nightfly', 'moonfly', 'tokyonight', 'rose-pine', 'lackluster', 'aura-dark' }
      vim.ui.select(themes, { prompt = 'Select theme:' }, function(choice)
        if choice then
          vim.cmd.colorscheme(choice)
        end
      end)
    else
      pcall(vim.cmd.colorscheme, theme)
    end
  end, {
    nargs = '?',
    complete = function()
      return { 'nightfly', 'moonfly', 'tokyonight', 'rose-pine', 'lackluster', 'aura-dark' }
    end,
  })
end

return {
  -- Active theme (nightfly)
  {
    'bluz71/vim-nightfly-colors',
    name = 'nightfly',
    lazy = ACTIVE_THEME ~= 'nightfly',
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      if ACTIVE_THEME == 'nightfly' then
        vim.cmd.colorscheme 'nightfly'
        vim.api.nvim_set_hl(0, 'Comment', { italic = true })
      end
      setup_theme_switcher()
    end,
  },

  -- Alternative themes (lazy-loaded)
  {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    lazy = ACTIVE_THEME ~= 'moonfly',
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      if ACTIVE_THEME == 'moonfly' then
        vim.cmd.colorscheme 'moonfly'
        vim.api.nvim_set_hl(0, 'Comment', { italic = true })
      end
    end,
  },

  {
    'folke/tokyonight.nvim',
    lazy = ACTIVE_THEME ~= 'tokyonight',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'night',
        transparent = true,
        styles = { comments = { italic = false } },
      }
      if ACTIVE_THEME == 'tokyonight' then
        vim.cmd.colorscheme 'tokyonight'
      end
    end,
  },

  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = ACTIVE_THEME ~= 'rose-pine',
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        styles = { italic = true },
      }
      if ACTIVE_THEME == 'rose-pine' then
        vim.cmd.colorscheme 'rose-pine'
      end
    end,
  },

  {
    'slugbyte/lackluster.nvim',
    name = 'lackluster',
    lazy = ACTIVE_THEME ~= 'lackluster',
    priority = 1000,
    config = function()
      require('lackluster').setup {
        -- NOTE: there was a tweak color attribute
      }
      if ACTIVE_THEME == 'lackluster' then
        vim.cmd.colorscheme 'lackluster'
      end
    end,
  },

  {
    'baliestri/aura-theme',
    lazy = ACTIVE_THEME ~= 'aura-dark',
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
      if ACTIVE_THEME == 'aura-dark' then
        vim.cmd.colorscheme 'aura-dark'
      end
    end,
  },
}
