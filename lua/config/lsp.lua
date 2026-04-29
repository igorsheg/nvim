-- Native Neovim LSP setup.
-- Server definitions live in lua/lsp/*.lua.

local icons = require("core.icons")
local map = require("core.keymap").map

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local function lsp_map(lhs, rhs, desc)
      map("n", lhs, rhs, desc, { buffer = event.buf })
    end

    lsp_map("gd", vim.lsp.buf.definition, "Go to definition")
    lsp_map("gt", vim.lsp.buf.type_definition, "Go to type definition")
    lsp_map("gi", vim.lsp.buf.implementation, "Go to implementation")
    lsp_map("gr", vim.lsp.buf.references, "Go to references")
    lsp_map("gD", vim.lsp.buf.declaration, "Go to declaration")

    lsp_map("K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, "Hover")
    lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename")
    lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code action")

    lsp_map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Previous diagnostic")

    lsp_map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")
  end,
})

vim.diagnostic.config({
  virtual_text = {
    prefix = icons.diagnostics.hint,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
    },
  },
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

local ok, blink = pcall(require, "blink.cmp")
if ok then
  vim.lsp.config("*", {
    capabilities = blink.get_lsp_capabilities(),
  })
end

-- Load every file in lua/lsp/. Each file should call vim.lsp.config(...).
for _, file in ipairs(vim.api.nvim_get_runtime_file("lua/lsp/*.lua", true)) do
  dofile(file)
end

vim.lsp.enable({
  "lua_ls",
  "vtsls",
  "eslint",
  "rust_analyzer",
  "gopls",
  "zls",
})
