local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    ensure_installed = {
      "lua_ls",
      "cssls",
      "html",
      "bashls",
      "jsonls",
      "yamlls",
      "marksman",
      "tailwindcss",
      "vtsls",
      "typos_lsp",
    },
    automatic_installation = true,
  },
}

function M.config(_, opts)
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }
  require("mason-lspconfig").setup(opts)
end

return M
