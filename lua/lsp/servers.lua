--[[
lua/lsp/servers.lua - Server Configurations

Like Go's service configuration (database connections, API endpoints),
this defines how to connect to and configure various language servers.

Think of this as:
  package config

  type DatabaseConfig struct {
    Host     string
    Port     int
    Database string
  }

  var Servers = map[string]DatabaseConfig{
    "postgres": {Host: "localhost", Port: 5432, Database: "app"},
    "redis":    {Host: "localhost", Port: 6379},
  }
--]]

local M = {}

-- Language profiles for quick setup of new languages
M.language_profiles = {
  -- Web Development Profile
  web = {
    'ts_ls',
    'html',
    'cssls',
    'jsonls',
    'tailwindcss',
    'eslint',
  },

  -- Systems Programming Profile
  systems = {
    'clangd',
    'rust_analyzer',
    'gopls',
  },

  -- Data Science Profile
  data = {
    'pyright',
    'r_language_server',
    'julials',
  },

  -- DevOps Profile
  devops = {
    'yamlls',
    'dockerls',
    'terraform_ls',
    'bashls',
  },
}

-- Base server configurations
M.servers = {
  -- Go language server
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
        semanticTokens = true,
      },
    },
  },

  -- Python language server
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
          typeCheckingMode = 'basic',
        },
      },
    },
  },

  -- Rust analyzer
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          enable = false,
        },
      },
    },
  },

  -- SQL language server with database connections
  sqlls = {
    filetypes = { 'sql', 'mysql' },
    settings = {
      sqls = {
        connections = {
          {
            driver = 'postgresql',
            dataSourceName = 'postgres://greenlight:pass@localhost/greenlight?sslmode=disable',
          },
          {
            driver = 'sqlite3',
            dataSourceName = '/path/to/your/database.db',
          },
        },
      },
    },
  },

  -- Web development servers
  ts_ls = {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
    init_options = {
      plugins = {
        {
          name = '@styled/typescript-styled-plugin',
          location = 'global',
        },
      },
    },
    settings = {
      typescript = {
        preferences = {
          disableSuggestions = false,
          includePackageJsonAutoImports = 'auto',
        },
        suggest = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
        },
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        preferences = {
          disableSuggestions = false,
          includePackageJsonAutoImports = 'auto',
        },
        suggest = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
        },
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  html = { filetypes = { 'html' } },
  cssls = { filetypes = { 'css', 'scss', 'less' } },
  jsonls = { filetypes = { 'json', 'jsonc' } },
  tailwindcss = {
    filetypes = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  },

  eslint = {
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    settings = {
      workingDirectory = { mode = 'auto' },
      format = { enable = true },
      lint = { enable = true },
      autoFixOnSave = false,
      codeActionOnSave = { enable = false, mode = 'all' },
    },
  },

  -- Lua language server (for Neovim config)
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        hint = { enable = true },
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },

  -- Additional language servers for easy expansion
  clangd = {},
  bashls = {},
  yamlls = {},
  dockerls = {},
  terraform_ls = {},
  r_language_server = {},
  julials = {},
}

-- Tools to ensure are installed (organized by category)
M.ensure_installed = {
  -- Formatters
  'stylua', -- Lua formatter
  'prettierd', -- Faster prettier (removed prettier for duplicate)
  'black', -- Python formatter
  'isort', -- Python import sorter
  'gofumpt', -- Go formatter

  -- Linters
  'eslint-lsp', -- Fast ESLint
  'pylint', -- Python linter

  -- Language Servers
  'sqls', -- SQL language server

  -- Debug Adapters (for future debugging setup)
  'delve', -- Go debugger
  'debugpy', -- Python debugger
}

-- Helper function to enable language profile
function M.enable_profile(profile_name)
  local profile = M.language_profiles[profile_name]
  if not profile then
    vim.notify('Unknown language profile: ' .. profile_name, vim.log.levels.ERROR)
    return
  end

  -- Add profile servers to ensure_installed
  for _, server in ipairs(profile) do
    if M.servers[server] then
      table.insert(M.ensure_installed, server)
    end
  end
end

-- Quick language setup function
function M.add_language(lang_config)
  -- lang_config = { name = 'zig', server = 'zls', formatters = {'zigfmt'}, linters = {} }
  if lang_config.server then
    M.servers[lang_config.server] = lang_config.config or {}
  end

  if lang_config.formatters then
    for _, formatter in ipairs(lang_config.formatters) do
      table.insert(M.ensure_installed, formatter)
    end
  end

  if lang_config.linters then
    for _, linter in ipairs(lang_config.linters) do
      table.insert(M.ensure_installed, linter)
    end
  end
end

return M
