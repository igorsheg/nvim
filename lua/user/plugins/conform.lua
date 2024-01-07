local M = {
  "stevearc/conform.nvim",
}
function M.config()
  require("conform").setup {
    formatters_by_ft = {
      lua = { "stylua" },
      typescript = { { "eslint", "prettierd", "prettier" } },
      javascript = { { "eslint", "prettierd", "prettier" } },
      json = { { "eslint", "prettierd", "prettier" } },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },
  }
end

return M
