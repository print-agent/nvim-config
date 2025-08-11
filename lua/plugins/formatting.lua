--[[
lua/plugins/formatting.lua - Code Formatting

Like Go's code formatters (gofmt, goimports) and linters,
this ensures consistent code style across the project.

Think of this as:
  package format

  func FormatGo(code string) string { return gofmt(code) }
  func FormatJS(code string) string { return prettier(code) }
  func LintCode(file string) []Error { return eslint(file) }
--]]

return {
  -- Automatic code formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,

      -- Auto-format on save with language-specific timeout
      format_on_save = function(bufnr)
        -- Disable for certain filetypes
        local disable_filetypes = { c = true, cpp = true }
        local filetype = vim.bo[bufnr].filetype

        if disable_filetypes[filetype] then
          return nil
        end

        -- Adjust timeout based on file type
        local timeout_map = {
          go = 2000, -- Go can be slower due to imports
          python = 1500, -- Python with black can be slow
          rust = 3000, -- Rust formatting can be very slow
          default = 500,
        }

        return {
          timeout_ms = timeout_map[filetype] or timeout_map.default,
          lsp_format = 'fallback',
        }
      end,

      -- Enhanced formatter configurations by filetype
      formatters_by_ft = {
        -- Lua
        lua = { 'stylua' },

        -- Python (multiple formatters in sequence)
        python = { 'isort', 'black' },

        -- Go (enhanced with goimports)
        go = { 'goimports', 'gofumpt' },

        -- Rust
        rust = { 'rustfmt' },

        -- C/C++
        c = { 'clang-format' },
        cpp = { 'clang-format' },

        -- SQL
        sql = { 'sql_formatter' },

        -- Web development (with fallback chain)
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },

        -- Shell scripts
        bash = { 'shfmt' },
        sh = { 'shfmt' },

        -- Docker
        dockerfile = { 'dockerls' },

        -- Markdown
        markdown = { 'prettier' },

        -- Add more languages as needed
        -- zig = { 'zigfmt' },
        -- dart = { 'dartfmt' },
        -- elixir = { 'mix' },
      },

      -- Custom formatter configurations
      formatters = {
        -- Custom shfmt options
        shfmt = {
          prepend_args = { '-i', '2', '-ci' }, -- 2 space indent, indent switch cases
        },
        -- Custom prettier options
        prettier = {
          prepend_args = { '--single-quote', '--trailing-comma', 'es5' },
        },
        -- Custom black options
        black = {
          prepend_args = { '--line-length', '88' },
        },
      },
    },
  },

  -- Automatic indentation detection
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },
}
