local M = {
  "jose-elias-alvarez/null-ls.nvim",
}

function M.config()
  local null_ls = require "null-ls"

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions

  null_ls.setup {
    sources = {
      diagnostics.eslint_d,
      code_actions.eslint_d,
      formatting.stylua,
      formatting.prettierd,
      formatting.prettierd.with {
        extra_filetypes = { "toml" },
      },
      null_ls.builtins.completion.spell,
    },
  }
end

return M
