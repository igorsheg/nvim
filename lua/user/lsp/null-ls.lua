local null_ls_ok, null_ls = pcall(require, "null-ls")

if not null_ls_ok then
  return
end

local fmt = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
--
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  debug = false,
  sources = {
    -- fmt.prettierd.with({
    --   extra_args = {
    --     "--no-semi",
    --     "--single-quote",
    --     "--jsx-single-quote",
    --   },
    -- }),
    -- fmt.stylua,
    -- fmt.rustfmt,
    -- fmt.latexindent,
    -- fmt.gofmt,
    diagnostics.eslint,
    code_actions.eslint,
    -- fmt.taplo,
    fmt.prettierd,
    -- fmt.nixpkgs_fmt,
    -- fmt.sqlfluff.with({
    --   extra_args = { "--dialect", "sqlite" }, -- change to your dialect
    -- }),
  },
  -- you can reuse a shared lspconfig on_attach callback here
  -- on_attach = function(client, bufnr)
  --   if client.supports_method("textDocument/formatting") then
  --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
  --         -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
  --         vim.lsp.buf.format({ async = false })
  --       end,
  --     })
  --   end
  -- end,
})
