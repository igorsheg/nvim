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
        html = { "prettier" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        graphql = { "prettierd" },
        lua = { "stylua" },
        python = { "isort", "black" },
        nix = { "nixfmt" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
      -- formatters = {
      --   prettier = {
      --     command = "/Users/igors/.local/share/nvim/mason/bin/prettier",
      --   },
      -- },
    }

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format { async = true, lsp_format = "fallback", range = range }
    end, { range = true })
  end,
}
