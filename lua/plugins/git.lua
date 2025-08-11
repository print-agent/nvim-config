--[[
lua/plugins/git.lua - Git Integration

Like Go's version control integration and CI/CD pipelines,
this provides Git functionality within the editor.

Think of this as:
  package vcs
  
  func GetStatus() []Change { ... }
  func ShowDiff(file string) Diff { ... }
  func StageChanges(hunks []Hunk) error { ... }
--]]

return {
  -- Git signs in the gutter
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- Visual indicators for different types of changes
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },

      -- Git hunk operations (like patch management)
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation between hunks (like navigating changes)
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next git hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Previous git hunk' })

        -- Actions (like git operations)
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git [H]unk [S]tage' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Git [H]unk [R]eset' })
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git [H]unk [S]tage' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git [H]unk [R]eset' })

        -- Buffer-wide operations
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Git [H]unk [S]tage buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git [H]unk [R]eset buffer' })

        -- Hunk information
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git [H]unk [P]review' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'Git [H]unk [B]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git [H]unk [D]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '~'
        end, { desc = 'Git [H]unk [D]iff against last commit' })

        -- Toggles (like feature flags)
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [B]lame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
