--[[
lua/plugins/syntax.lua - Syntax Highlighting

Like Go's AST parser and syntax analyzer,
this provides intelligent code parsing and highlighting.

Think of this as:
  package parser
  
  func ParseGo(source string) AST { ... }
  func HighlightSyntax(ast AST) HighlightTree { ... }
  func DetectLanguage(file string) Language { ... }
--]]

return {
  -- Tree-sitter for syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      -- Languages to ensure are installed (like compiler targets)
      ensure_installed = {
        -- System languages
        'bash',
        'c',
        'python',
        'go',
        'lua',
        'vim',
        'vimdoc',

        -- Web development
        'typescript',
        'javascript',
        'tsx',
        'html',
        'css',
        'json',

        -- Data formats
        'sql',
        'markdown',
        'markdown_inline',

        -- Development tools
        'diff',
        'query',
        'luadoc',
      },

      -- Automatically install parsers for opened files
      auto_install = true,

      -- Enable syntax highlighting
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting
        additional_vim_regex_highlighting = { 'ruby' },
      },

      -- Enable smart indentation
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
    },
  },

  -- Enhanced SQL syntax highlighting
  {
    'joereynolds/SQHell.vim',
    ft = { 'sql' },
  },
}
