local navic = require("nvim-navic")
local lspconfig = require("lspconfig")
local rt_ok, rust_tools = pcall(require, "rust-tools")
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

local M = {}

if not cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.autoformat = true

M.setup = function()
  require("user.lsp.diagnostic")
end

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = "rounded",
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  }),
}

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
  keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

local function on_attach(client, bufnr)
  lsp_keymaps(bufnr)
  -- vim.cmd.autocmd("BufWritePre <buffer> lua vim.lsp.buf.format()")
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

lspconfig.eslint.setup({
  settings = {
    packageManager = 'yarn'
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})


for _, server in ipairs({ "bashls", "rnix", "html", "diagnosticls", "marksman", }) do
  lspconfig[server].setup({
    on_attach = on_attach,
    capabilities = M.capabilities,
    handlers = handlers,
  })
end


lspconfig.cssls.setup({
  capabilities = M.capabilities,
  handlers = handlers,
  on_attach = on_attach,
})

lspconfig.gopls.setup({
  capabilities = M.capabilities,
  handlers = handlers,
  on_attach = on_attach,
})

lspconfig.jsonls.setup({
  capabilities = M.capabilities,
  handlers = handlers,
  on_attach = on_attach,
  settings = require("user.lsp.servers.jsonls").settings,
})


if vim.fn.executable("lua-language-server") == 1 then
  lspconfig.lua_ls.setup({
    capabilities = M.capabilities,
    handlers = handlers,
    on_attach = on_attach,
  })
end

lspconfig.tailwindcss.setup({
  capabilities = M.capabilities,
  handlers = handlers,
  on_attach = on_attach,
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "classList", "ngClass" },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
      validate = true,
    },
  },
})

if vim.fn.executable("rust-analyzer") == 1 then
  if rt_ok then
    rust_tools.setup({
      tools = {
        on_initialized = function()
          vim.cmd([[
                  augroup RustLSP
                    autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                    autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                  augroup END
                ]])
        end,
        executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
        reload_workspace_from_cargo_toml = true,
        runnables = {
          use_telescope = true,
        },
        inlay_hints = {
          auto = true,
          only_current_line = false,
          show_parameter_hints = false,
          parameter_hints_prefix = "<-",
          other_hints_prefix = "=>",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = false,
          right_align_padding = 7,
          highlight = "Comment",
        },
        hover_actions = {
          border = "rounded",
        },
      },
      server = {
        on_attach = on_attach,
        capabilities = M.capabilities,
        handlers = handlers,
        -- standalone = false,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            lens = {
              enable = true,
            },
            checkOnSave = {
              enable = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    })
  end
end

return M
