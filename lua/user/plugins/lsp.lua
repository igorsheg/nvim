local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/neodev.nvim",
      "yioneko/nvim-vtsls",
    },
  },
}

local function lsp_keymaps()
  local map = require("user.utils").map
  -- map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  -- map("n", "gd", "<cmd>Trouble lsp_definitions<CR>")
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  -- map("n", "gI", "<cmd>Trouble lsp_implementations<CR>")
  -- map("n", "gr", "<cmd>Trouble lsp_references<CR>")
  -- map("n", "gt", "<cmd>Trouble lsp_type_definitions<CR>")
  -- map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
  map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  -- map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  -- map("n", "<leader>lh", "<cmd>lua require('user.plugins.lsp').toggle_inlay_hints()<CR>")
  -- map("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<CR>")
  -- map("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>")
  map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>")

  map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
  map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
end

M.on_attach = function()
  lsp_keymaps()
end

function M.common_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  return capabilities
end

-- local function setup_typedkey_lsp(lspconfig, configs, util)
--   if not configs.typedkey_lsp then
--     configs.typedkey_lsp = {
--       default_config = {
--         cmd = { "/users/igors/workspace/dev/personal/typed-key/target/release/typed-key" },
--         filetypes = {
--           "javascript",
--           "javascriptreact",
--           "javascript.jsx",
--           "typescript",
--           "typescriptreact",
--           "typescript.tsx",
--         },
--         single_file_support = true,
--         root_dir = util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
--         settings = {},
--       },
--     }
--   end
--
--   lspconfig.typedkey_lsp.setup {
--     on_attach = M.on_attach,
--     capabilities = M.common_capabilities(),
--     settings = {
--       translationsDir = "/src/assets/locales",
--     },
--     init_options = {
--       translationsDir = "/src/assets/locales",
--       logLevel = "debug",
--     },
--   }
-- end

M.toggle_inlay_hints = function(bufnr)
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr }, { bufnr })
end

function M._attach(client, _)
  vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"
  client.server_capabilities.semanticTokensProvider = nil
  local original = vim.notify
  local mynotify = function(msg, level, opts)
    if msg == "No code actions available" or msg:find "overly" then
      return
    end
    original(msg, level, opts)
  end
  vim.notify = mynotify
end

function M.config()
  local lspconfig = require "lspconfig"
  local configs = require "lspconfig.configs"
  local icons = require "user.utils.icons"
  local util = require "lspconfig.util"
  -- vim.lsp.set_log_level "debug"

  -- setup_typedkey_lsp(lspconfig, configs, util)

  configs.protobuf_language_server = {
    default_config = {
      cmd = { "protobuf-language-server" },
      filetypes = { "proto", "cpp" },
      root_dir = util.root_pattern ".git",
      single_file_support = true,
    },
  }

  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "rnix",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
    "marksman",
    "gopls",
    -- "pbls",
    "zls",
    "protobuf_language_server",
    -- "typedkey_lsp",
    "rust_analyzer",
  }

  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
      },
    },
    virtual_text = {
      spacing = 12,
      prefix = "",
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  require("lspconfig.ui.windows").default_options.border = "rounded"
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 4,
      prefix = "", -- dot
      min = "Warning",
    },
    severity_sort = true,
    update_in_insert = true,
  })

  for _, server in pairs(servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    if server == "lua_ls" then
      require("neodev").setup {}
    end

    lspconfig.vtsls.setup {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
      root_dir = util.root_pattern "package.json",
      settings = {
        vtsls = {
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          tsserver = {
            experimental = {
              enableProjectDiagnostics = false,
            },
          },
          inlayHints = {
            parameterNames = { enabled = false },
            parameterTypes = { enabled = false },
            variableTypes = { enabled = false },
            propertyDeclarationTypes = { enabled = false },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = false },
          },
        },
      },
    }

    lspconfig.typos_lsp.setup {
      init_options = {
        diagnosticSeverity = "Warning",
      },
    }

    lspconfig.eslint.setup {
      settings = {
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine",
          },
          showDocumentation = {
            enable = true,
          },
        },
        codeActionOnSave = {
          enable = false,
          mode = "all",
        },
        format = true,
        nodePath = "",
        onIgnoredFiles = "off",
        packageManager = "npm",
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
        useESLintClass = false,
        validate = "on",
        workingDirectory = {
          mode = "location",
        },
      },
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    }

    lspconfig[server].setup(opts)
  end
end

return M
