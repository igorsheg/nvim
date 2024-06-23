return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = {
        -- typescript = { { "prettier" } },
        -- javascript = { { "prettier" } },
        -- javascriptreact = { { "prettier" } },
        -- typescriptreact = { { "prettier" } },
        svelte = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        graphql = { "prettierd" },
        lua = { "stylua" },
        python = { "isort", "black" },
        nix = { "nixfmt" },
      },
      -- formatters = {
      --   prettierd = {
      --     prepend_args = {
      --       "--single-quote=true",
      --       "--trailing-comma=all",
      --     },
      --   },
      -- },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    }
  end,
}
