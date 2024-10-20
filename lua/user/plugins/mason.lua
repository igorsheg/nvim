local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = function()
    require("mason").setup {
      ui = {
        border = "rounded",
      },
    }
    require("mason-lspconfig").setup {
      ensure_installed = {
        "lua_ls",
        "cssls",
        "html",
        "pyright",
        "bashls",
        "jsonls",
        "yamlls",
        "marksman",
        "tailwindcss",
        "vtsls",
        "typos_lsp",
      },
      automatic_installation = true,
    }
  end,
}

-- M.servers = {
--   "lua_ls",
--   "cssls",
--   "html",
--   "tsserver",
--   "pyright",
--   "bashls",
--   "jsonls",
--   "yamlls",
--   "marksman",
--   "tailwindcss",
--   "vtsls",
--   "typos_lsp",
--   "eslint"
-- }

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }
  require("mason-lspconfig").setup {
    -- ensure_installed = M.servers,
    automatic_installation = true,
  }
end

return M
