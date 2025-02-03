local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "folke/neodev.nvim", "yioneko/nvim-vtsls" },
  },
}

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
local function lsp_keymaps()
  local keymap = vim.keymap.set
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>")
  keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
  keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
end

M.on_attach = function()
  lsp_keymaps()
end

--------------------------------------------------------------------------------
-- Capabilities
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Custom attach function
--------------------------------------------------------------------------------
function M._attach(client, _)
  vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"
  client.server_capabilities.semanticTokensProvider = nil

  local original_notify = vim.notify
  vim.notify = function(msg, level, opts)
    if msg == "No code actions available" or msg:find "overly" then
      return
    end
    original_notify(msg, level, opts)
  end
end

--------------------------------------------------------------------------------
-- LSP Config
--------------------------------------------------------------------------------
function M.config()
  local lspconfig = require "lspconfig"
  local configs = require "lspconfig.configs"
  local icons = require "user.utils.icons"
  local util = require "lspconfig.util"

  ------------------------------------------------------------------------------
  -- Protobuf Language Server setup
  ------------------------------------------------------------------------------
  configs.protobuf_language_server = {
    default_config = {
      cmd = { "protobuf-language-server" },
      filetypes = { "proto", "cpp" },
      root_dir = util.root_pattern ".git",
      single_file_support = true,
    },
  }

  ------------------------------------------------------------------------------
  -- Diagnostic configuration
  ------------------------------------------------------------------------------
  local diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
      },
    },
    virtual_text = { spacing = 12, prefix = "" },
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
    format = { formatting_options = nil, timeout_ms = nil },
  }
  vim.diagnostic.config(diagnostic_config)

  ------------------------------------------------------------------------------
  -- LSP UI Handlers
  ------------------------------------------------------------------------------
  require("lspconfig.ui.windows").default_options.border = "rounded"
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = { spacing = 4, prefix = "", min = "Warning" },
    severity_sort = true,
    update_in_insert = true,
  })

  ------------------------------------------------------------------------------
  -- Setup LSP servers from list
  ------------------------------------------------------------------------------
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
    "zls",
    "protobuf_language_server",
    "rust_analyzer",
  }

  for _, server in ipairs(servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    local ok, settings = pcall(require, "user.lspsettings." .. server)
    if ok then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    if server == "lua_ls" then
      require("neodev").setup {}
    end

    lspconfig[server].setup(opts)
  end

  ------------------------------------------------------------------------------
  -- Additional server setups (not in the servers list)
  ------------------------------------------------------------------------------
  lspconfig.vtsls.setup {
    on_attach = M.on_attach,
    capabilities = M.common_capabilities(),
    root_dir = util.root_pattern "package.json",
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
        experimental = {
          completion = { enableServerSideFuzzyMatch = true },
        },
      },
      typescript = {
        tsserver = {
          useSeparateSyntaxServer = true,
          maxTsServerMemory = 4096,
          logVerbosity = "off",
          experimental = {
            enableProjectDiagnostics = false,
            disableAutomaticTypingAcquisition = true,
          },
        },
        inlayHints = {
          -- parameterNames = { enabled = false },
          -- parameterTypes = { enabled = false },
          -- variableTypes = { enabled = false },
          -- propertyDeclarationTypes = { enabled = false },
          -- functionLikeReturnTypes = { enabled = true },
          -- enumMemberValues = { enabled = false },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
  }

  lspconfig.typos_lsp.setup {
    init_options = { diagnosticSeverity = "Warning" },
  }

  lspconfig.eslint.setup {
    settings = {
      codeAction = {
        disableRuleComment = { enable = true, location = "separateLine" },
        showDocumentation = { enable = true },
      },
      codeActionOnSave = { enable = false, mode = "all" },
      format = true,
      nodePath = "",
      onIgnoredFiles = "off",
      packageManager = "npm",
      quiet = false,
      rulesCustomizations = {},
      run = "onType",
      useESLintClass = false,
      validate = "on",
      workingDirectory = { mode = "location" },
    },
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
  }
end

return M
