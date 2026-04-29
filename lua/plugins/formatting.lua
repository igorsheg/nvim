return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>=",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format",
      },
    },
    opts = {
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype

        if vim.tbl_contains({ "javascript", "javascriptreact", "typescript", "typescriptreact" }, ft) then
          vim.cmd("silent! EslintFixAll")
          return nil
        end

        return {
          timeout_ms = 1000,
          lsp_format = "fallback",
        }
      end,
      formatters_by_ft = {
        go = { "gofmt" },
        lua = { "stylua" },
        rust = { "rustfmt" },
        zig = { "zigfmt" },
      },
      formatters = {
        zigfmt = {
          command = "zig",
          args = { "fmt", "$FILENAME" },
          stdin = false,
        },
      },
    },
  },
}
