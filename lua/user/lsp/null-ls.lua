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
    diagnostics.eslint_d,
    code_actions.eslint_d,
    -- fmt.taplo,
    fmt.prettierd,
    -- fmt.prettier_eslint,
    -- fmt.nixpkgs_fmt,
    -- fmt.sqlfluff.with({
    --   extra_args = { "--dialect", "sqlite" }, -- change to your dialect
    -- }),
  },
  -- you can reuse a shared lspconfig on_attach callback here
})
